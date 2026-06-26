import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/responsive.dart';
import '../../../providers/payment_provider.dart';
import '../../../data/models/payment_history_model.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentProvider>().fetchHistory();
    });
  }

  String _formatDate(DateTime? d) {
    if (d == null) return '';
    return "${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}";
  }

  String _formatAmount(num v) {
    final whole = v.round();
    final str = whole.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      final fromEnd = str.length - i;
      buffer.write(str[i]);
      if (fromEnd > 1 && (fromEnd - 1) % 3 == 0 && fromEnd != str.length) {
        buffer.write(',');
      }
    }
    return '₹${buffer.toString()}';
  }

  Widget buildSummaryCard(BuildContext context, String value, String label, Widget icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE9E9E9), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.015),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(height: context.h(24), width: context.h(24), child: icon),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(fontSize: context.sp(16), fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: Colors.grey, fontSize: context.sp(11.5), fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }

  Widget buildInvoiceCard(BuildContext context, {
    required String title,
    required String reference,
    required String date,
    required String price,
    required bool paid,
    required String statusLabel,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9E9E9), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(
                  'assets/images/document.svg',
                  height: 20,
                  width: 20,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: context.sp(13.5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      reference,
                      style: TextStyle(color: Colors.grey, fontSize: context.sp(11), fontWeight: FontWeight.w400),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: paid
                      ? Colors.green.withOpacity(0.08)
                      : Colors.red.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: paid ? Colors.green : Colors.red,
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      paid ? Icons.check_circle : Icons.warning_amber_rounded,
                      size: 13,
                      color: paid ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      statusLabel,
                      style: TextStyle(
                        color: paid ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500,
                        fontSize: context.sp(9.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: TextStyle(color: Colors.grey, fontSize: context.sp(11.5), fontWeight: FontWeight.w400),
              ),
              Text(
                price,
                style: TextStyle(
                  fontSize: context.sp(13.5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, PaymentProvider provider) {
    if (provider.isHistoryLoading && provider.history.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: Colors.orange));
    }

    if (provider.historyError != null && provider.history.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
            const SizedBox(height: 12),
            Text(provider.historyError!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 12),
            TextButton(onPressed: () => provider.fetchHistory(), child: const Text("Retry")),
          ],
        ),
      );
    }

    final items = provider.history;

    return Column(
      children: [
        /// TOP SUMMARY
        Row(
          children: [
            buildSummaryCard(
              context,
              _formatAmount(provider.totalPaid),
              "Total Paid",
              SvgPicture.asset('assets/images/moneys.svg', height: 20, width: 20, fit: BoxFit.contain),
            ),
            const SizedBox(width: 12),
            buildSummaryCard(
              context,
              items.length.toString(),
              "Invoices",
              SvgPicture.asset('assets/images/view_plans.svg', height: 20, width: 20, fit: BoxFit.contain),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: items.isEmpty
              ? const Center(
                  child: Text(
                    "No invoices yet.\nYour payments will appear here.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => provider.fetchHistory(),
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final PaymentHistoryItem item = items[index];
                      final ref = item.invoiceNumber != null && item.invoiceNumber!.isNotEmpty
                          ? "Ref: ${item.invoiceNumber}"
                          : "Ref: ${item.id.length >= 8 ? item.id.substring(0, 8).toUpperCase() : item.id}";
                      final statusLabel = item.isPaid
                          ? "Paid"
                          : (item.status.isEmpty ? "Pending" : _titleCase(item.status));
                      return buildInvoiceCard(
                        context,
                        title: item.title,
                        reference: ref,
                        date: _formatDate(item.createdAt),
                        price: _formatAmount(item.amount),
                        paid: item.isPaid,
                        statusLabel: statusLabel,
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  String _titleCase(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentProvider>();
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Invoices & Bills",
          style: TextStyle(
            color: Colors.black,
            fontSize: context.sp(18),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.all(context.w(16)),
        child: _buildBody(context, provider),
      ),
    );
  }
}
