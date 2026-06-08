import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/subscription_provider.dart';
import '../../../data/models/dto/subscription_list_response.dart';

class SubscriptionDetailsScreen extends StatefulWidget {
  final String subscriptionId;

  const SubscriptionDetailsScreen({
    super.key,
    required this.subscriptionId,
  });

  @override
  State<SubscriptionDetailsScreen> createState() => _SubscriptionDetailsScreenState();
}

class _HomeScreenDetailsRow extends StatelessWidget {
  final String label;
  final String value;

  const _HomeScreenDetailsRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 14, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _SubscriptionDetailsScreenState extends State<SubscriptionDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubscriptionProvider>().fetchSubscriptionDetails(widget.subscriptionId);
    });
  }

  String _formatDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return 'N/A';
    try {
      final dateTime = DateTime.parse(isoString);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return "${dateTime.day.toString().padLeft(2, '0')} ${months[dateTime.month - 1]} ${dateTime.year}";
    } catch (_) {
      if (isoString.length >= 10) return isoString.substring(0, 10);
      return isoString;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return const Color(0xFFE8F8EF);
      case 'PAUSED':
        return const Color(0xFFFFF3E0);
      case 'CANCELLED':
        return const Color(0xFFFFEBEE);
      default:
        return const Color(0xFFEEEEEE);
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return const Color(0xFF2E7D32);
      case 'PAUSED':
        return const Color(0xFFEF6C00);
      case 'CANCELLED':
        return const Color(0xFFC62828);
      default:
        return const Color(0xFF616161);
    }
  }

  Widget _buildPaymentSummaryCard(SubscriptionModel sub) {
    final subscriptionAmount = sub.planPricing?.price ?? 0;
    final platformFee = sub.platformFee ?? 99;
    final totalPaid = subscriptionAmount + platformFee;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Payment Summary",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          _HomeScreenDetailsRow(label: "Subscription Amount", value: "₹$subscriptionAmount"),
          _HomeScreenDetailsRow(
            label: "Platform Fee (Non-refundable)",
            value: "₹$platformFee",
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Paid",
                style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                "₹$totalPaid",
                style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "The platform fee is non-refundable and covers operational and processing costs.",
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildRefundStatusCard(SubscriptionModel sub) {
    if (sub.refundStatus == null || sub.refundStatus!.isEmpty) {
      return const SizedBox.shrink();
    }

    Color badgeBgColor;
    Color badgeBorderColor;
    Color badgeTextColor;
    String statusText;
    String statusDesc;
    IconData icon;

    switch (sub.refundStatus!.toLowerCase()) {
      case 'completed':
        badgeBgColor = const Color(0xFFE8F8EF);
        badgeBorderColor = Colors.green.shade300;
        badgeTextColor = Colors.green;
        statusText = "Completed";
        statusDesc = "Your refund has been successfully processed.";
        icon = Icons.check_circle;
        break;
      case 'failed':
        badgeBgColor = const Color(0xFFFEE2E2);
        badgeBorderColor = Colors.red.shade300;
        badgeTextColor = Colors.red;
        statusText = "Failed";
        statusDesc = "We were unable to process your refund. Please contact support.";
        icon = Icons.cancel;
        break;
      case 'processing':
      default:
        badgeBgColor = const Color(0xFFFFF9E6);
        badgeBorderColor = Colors.amber.shade300;
        badgeTextColor = const Color(0xFFD97706);
        statusText = "Processing";
        statusDesc = "Your refund has been initiated and is currently being processed.";
        icon = Icons.hourglass_empty;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Refund Status Details",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Refund Status",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: badgeBgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: badgeBorderColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: badgeTextColor, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      statusText.toUpperCase(),
                      style: TextStyle(color: badgeTextColor, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            statusDesc,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          const Divider(height: 24),
          const Text(
            "Refund Summary",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          if (sub.refundAmount != null) ...[
            _HomeScreenDetailsRow(label: "Refund Amount", value: "₹${sub.refundAmount}"),
          ],
          _HomeScreenDetailsRow(label: "Platform Fee (Non-refundable)", value: "₹${sub.platformFee ?? 99}"),
          const Divider(height: 24),
          if (sub.refundReason != null && sub.refundReason!.isNotEmpty) ...[
            _HomeScreenDetailsRow(label: "REASON", value: sub.refundReason!),
          ],
          if (sub.refundInitiatedAt != null && sub.refundInitiatedAt!.isNotEmpty) ...[
            _HomeScreenDetailsRow(label: "INITIATED AT", value: _formatDate(sub.refundInitiatedAt)),
          ],
          if (sub.refundCompletedAt != null && sub.refundCompletedAt!.isNotEmpty) ...[
            _HomeScreenDetailsRow(label: "COMPLETED AT", value: _formatDate(sub.refundCompletedAt)),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subProvider = context.watch<SubscriptionProvider>();
    final sub = subProvider.subscriptionDetails;

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Subscription Details",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: () {
        if (subProvider.isDetailsLoading && sub == null) {
          return const Center(child: CircularProgressIndicator(color: Color(0xffF4C430)));
        }

        if (subProvider.detailsError != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
                  const SizedBox(height: 16),
                  const Text("Failed to load details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(subProvider.detailsError!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => subProvider.fetchSubscriptionDetails(widget.subscriptionId),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffF4C430)),
                    child: const Text("Retry", style: TextStyle(color: Colors.black)),
                  )
                ],
              ),
            ),
          );
        }

        if (sub == null) {
          return const Center(child: Text("Subscription not found"));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          sub.planPricing?.plan?.name ?? 'Subscription Plan',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getStatusBgColor(sub.status),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _getStatusTextColor(sub.status)),
                          ),
                          child: Text(
                            sub.status.toUpperCase(),
                            style: TextStyle(color: _getStatusTextColor(sub.status), fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "₹${sub.planPricing?.price ?? 0} / month",
                      style: const TextStyle(color: Color(0xffC68A00), fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    const Divider(height: 32),
                    _HomeScreenDetailsRow(label: "SUBSCRIPTION ID", value: sub.id),
                    _HomeScreenDetailsRow(label: "VEHICLE", value: "${sub.vehicle?.brand ?? ''} ${sub.vehicle?.model ?? ''} (${sub.vehicle?.vehicleNumber ?? ''})"),
                    _HomeScreenDetailsRow(label: "SLOT TYPE", value: sub.slotType?.toUpperCase() ?? 'MORNING'),
                    _HomeScreenDetailsRow(label: "START DATE", value: _formatDate(sub.startDate)),
                    _HomeScreenDetailsRow(label: "END DATE", value: _formatDate(sub.endDate)),
                    _HomeScreenDetailsRow(label: "CITY", value: sub.city?.name ?? 'N/A'),
                    _HomeScreenDetailsRow(label: "STATE", value: sub.city?.state ?? 'N/A'),
                  ],
                ),
              ),
              _buildPaymentSummaryCard(sub),
              _buildRefundStatusCard(sub),
              if (sub.status.toUpperCase() != 'PAUSED') ...[
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: subProvider.isPauseLoading
                        ? null
                        : () async {
                            final success = await subProvider.pauseSubscription(sub.id);
                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Subscription paused successfully"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Failed to pause subscription. Please try again."),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF6C00),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: subProvider.isPauseLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            "Pause Subscription",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ],
          ),
        );
      }(),
    );
  }
}
