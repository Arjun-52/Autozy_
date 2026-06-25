import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/subscription_provider.dart';
import '../../../core/utils/responsive.dart';

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
      padding: EdgeInsets.symmetric(vertical: context.h(5)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: context.sp(10.5), fontWeight: FontWeight.w500),
          ),
          SizedBox(width: context.w(16)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.black, fontSize: context.sp(11), fontWeight: FontWeight.w600),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
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
      backgroundColor: const Color(0xFFF9F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Subscription Details",
          style: TextStyle(
            color: Colors.black,
            fontSize: context.sp(16),
            fontWeight: FontWeight.w600,
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
              padding: EdgeInsets.all(context.w(32)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: context.w(64), color: Colors.redAccent),
                  SizedBox(height: context.h(16)),
                  Text(
                    "Failed to load details",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: context.sp(18)),
                  ),
                  SizedBox(height: context.h(8)),
                  Text(
                    subProvider.detailsError!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: context.sp(13), fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: context.h(24)),
                  ElevatedButton(
                    onPressed: () => subProvider.fetchSubscriptionDetails(widget.subscriptionId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffF4C430),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text("Retry", style: TextStyle(color: Colors.black, fontSize: context.sp(13), fontWeight: FontWeight.w600)),
                  )
                ],
              ),
            ),
          );
        }

        if (sub == null) {
          return Center(
            child: Text(
              "Subscription not found",
              style: TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.w500, color: Colors.grey),
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(context.w(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(context.w(16)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE9E9E9), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.015),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            sub.planPricing?.plan?.name ?? 'Subscription Plan',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: context.sp(14.5)),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: context.w(8), vertical: context.h(3)),
                          decoration: BoxDecoration(
                            color: _getStatusBgColor(sub.status),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _getStatusTextColor(sub.status)),
                          ),
                          child: Text(
                            sub.status.toUpperCase(),
                            style: TextStyle(color: _getStatusTextColor(sub.status), fontWeight: FontWeight.w600, fontSize: context.sp(9)),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: context.h(6)),
                    Text(
                      "₹${sub.planPricing?.price ?? 0} / month",
                      style: TextStyle(color: const Color(0xffC68A00), fontWeight: FontWeight.w600, fontSize: context.sp(13)),
                    ),
                    Divider(height: context.h(24)),
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
                SizedBox(height: context.h(20)),
                Center(
                  child: SizedBox(
                    width: context.w(220),
                    height: context.h(40),
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
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: subProvider.isPauseLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "Pause Subscription",
                              style: TextStyle(
                                fontSize: context.sp(12.5),
                                fontWeight: FontWeight.w600,
                              ),
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
