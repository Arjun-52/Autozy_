import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/subscription_provider.dart';

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
