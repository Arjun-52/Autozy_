import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/subscription_provider.dart';
import '../../../data/models/dto/subscription_list_response.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubscriptionProvider>().fetchSubscriptions();
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
      case 'PENDING_INSPECTION':
        return const Color(0xFFFFFDE7); // Yellowish light
      case 'ACTIVE':
        return const Color(0xFFE8F8EF); // Greenish light
      case 'PAUSED':
        return const Color(0xFFFFF3E0); // Orangish light
      case 'CANCELLED':
        return const Color(0xFFFFEBEE); // Reddish light
      case 'EXPIRED':
      default:
        return const Color(0xFFEEEEEE); // Greyish light
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING_INSPECTION':
        return const Color(0xFFF57F17);
      case 'ACTIVE':
        return const Color(0xFF2E7D32);
      case 'PAUSED':
        return const Color(0xFFEF6C00);
      case 'CANCELLED':
        return const Color(0xFFC62828);
      case 'EXPIRED':
      default:
        return const Color(0xFF616161);
    }
  }

  String _getStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING_INSPECTION':
        return 'Pending Inspection';
      case 'ACTIVE':
        return 'Active';
      case 'PAUSED':
        return 'Paused';
      case 'CANCELLED':
        return 'Cancelled';
      case 'EXPIRED':
        return 'Expired';
      default:
        return status;
    }
  }

  Widget _buildEmptyState(SubscriptionProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.card_membership_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              "No Subscriptions Found",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Create your first subscription to get started.",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => provider.fetchSubscriptions(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffF4C430),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Retry", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(SubscriptionProvider provider, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            const Text(
              "Unable to load subscriptions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error.contains('SocketException') ? 'Please check your internet connection.' : error,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => provider.fetchSubscriptions(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffF4C430),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Retry", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard(SubscriptionModel sub) {
    final planName = sub.planPricing?.plan?.name ?? 'Plan';
    final price = sub.planPricing?.price ?? 0;
    final vehicleBrand = sub.vehicle?.brand ?? '';
    final vehicleModel = sub.vehicle?.model ?? '';
    final vehicleNumber = sub.vehicle?.vehicleNumber ?? '';
    final slotType = sub.slotType ?? 'MORNING';

    final textStyleLabel = TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500);
    final textStyleValue = const TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w600);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW (PLAN & STATUS)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFECBC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SvgPicture.asset(
                  'assets/images/view_plans.svg',
                  height: 24,
                  width: 24,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      planName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "₹$price /month",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xffC68A00),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusBgColor(sub.status),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getStatusTextColor(sub.status),
                    width: 1,
                  ),
                ),
                child: Text(
                  _getStatusText(sub.status),
                  style: TextStyle(
                    color: _getStatusTextColor(sub.status),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),

          /// DETAILS GRID
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("VEHICLE", style: textStyleLabel),
                    const SizedBox(height: 4),
                    Text("$vehicleBrand $vehicleModel", style: textStyleValue),
                    Text(vehicleNumber, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("SLOT TYPE", style: textStyleLabel),
                    const SizedBox(height: 4),
                    Text(slotType.toUpperCase(), style: textStyleValue),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("START DATE", style: textStyleLabel),
                    const SizedBox(height: 4),
                    Text(_formatDate(sub.startDate), style: textStyleValue),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("END DATE", style: textStyleLabel),
                    const SizedBox(height: 4),
                    Text(_formatDate(sub.endDate), style: textStyleValue),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subProvider = context.watch<SubscriptionProvider>();
    final subscriptions = subProvider.subscriptions;
    final isListLoading = subProvider.isListLoading;
    final listError = subProvider.listError;

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "My Subscriptions",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => subProvider.refreshSubscriptions(),
        child: () {
          if (isListLoading && subscriptions.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xffF4C430),
              ),
            );
          }

          if (listError != null) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: _buildErrorState(subProvider, listError),
              ),
            );
          }

          if (subscriptions.isEmpty) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: _buildEmptyState(subProvider),
              ),
            );
          }

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: subscriptions.length,
            itemBuilder: (context, index) {
              final sub = subscriptions[index];
              return _buildSubscriptionCard(sub);
            },
          );
        }(),
      ),
    );
  }
}
