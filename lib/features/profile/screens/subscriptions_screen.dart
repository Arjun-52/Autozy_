import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/subscription_provider.dart';
import '../../../data/models/dto/subscription_list_response.dart';
import '../../../core/utils/responsive.dart';

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
        padding: EdgeInsets.all(context.w(32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.card_membership_outlined, size: context.w(64), color: Colors.grey),
            SizedBox(height: context.h(16)),
            Text(
              "No Subscriptions Found",
              style: TextStyle(fontSize: context.sp(18), fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(8)),
            Text(
              "Create your first subscription to get started.",
              style: TextStyle(color: Colors.grey, fontSize: context.sp(13), fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(24)),
            ElevatedButton(
              onPressed: () => provider.fetchSubscriptions(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffF4C430),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text("Retry", style: TextStyle(color: Colors.black, fontSize: context.sp(13), fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(SubscriptionProvider provider, String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.w(32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: context.w(64), color: Colors.redAccent),
            SizedBox(height: context.h(16)),
            Text(
              "Unable to load subscriptions",
              style: TextStyle(fontSize: context.sp(18), fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(8)),
            Text(
              error.contains('SocketException') ? 'Please check your internet connection.' : error,
              style: TextStyle(color: Colors.grey, fontSize: context.sp(13), fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(24)),
            ElevatedButton(
              onPressed: () => provider.fetchSubscriptions(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffF4C430),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text("Retry", style: TextStyle(color: Colors.black, fontSize: context.sp(13), fontWeight: FontWeight.w600)),
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

    final textStyleLabel = TextStyle(fontSize: context.sp(10), color: Colors.grey.shade600, fontWeight: FontWeight.w500);
    final textStyleValue = TextStyle(fontSize: context.sp(12.5), color: Colors.black, fontWeight: FontWeight.w600);

    return Container(
      margin: EdgeInsets.only(bottom: context.h(12)),
      padding: EdgeInsets.all(context.w(11)),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW (PLAN & STATUS)
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(context.w(8)),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFECBC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(
                  'assets/images/view_plans.svg',
                  height: context.w(20),
                  width: context.w(20),
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: context.w(10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      planName,
                      style: TextStyle(
                        fontSize: context.sp(14),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: context.h(2)),
                    Text(
                      "₹$price /month",
                      style: TextStyle(
                        fontSize: context.sp(12.5),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xffC68A00),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: context.w(8), vertical: context.h(4)),
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
                    fontSize: context.sp(10),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: context.h(12)),
          const Divider(),
          SizedBox(height: context.h(8)),

          /// DETAILS GRID
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("VEHICLE", style: textStyleLabel),
                    SizedBox(height: context.h(2)),
                    Text("$vehicleBrand $vehicleModel", style: textStyleValue),
                    Text(
                      vehicleNumber,
                      style: TextStyle(fontSize: context.sp(11), color: Colors.grey.shade600, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("SLOT TYPE", style: textStyleLabel),
                    SizedBox(height: context.h(2)),
                    Text(slotType.toUpperCase(), style: textStyleValue),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: context.h(12)),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("START DATE", style: textStyleLabel),
                    SizedBox(height: context.h(2)),
                    Text(_formatDate(sub.startDate), style: textStyleValue),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("END DATE", style: textStyleLabel),
                    SizedBox(height: context.h(2)),
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
      backgroundColor: const Color(0xFFF9F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "My Subscriptions",
          style: TextStyle(
            color: Colors.black,
            fontSize: context.sp(16),
            fontWeight: FontWeight.w600,
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
            padding: EdgeInsets.all(context.w(16)),
            itemCount: subscriptions.length,
            itemBuilder: (context, index) {
              final sub = subscriptions[index];
              return GestureDetector(
                onTap: () {
                  context.push('/subscription-details/${sub.id}');
                },
                child: _buildSubscriptionCard(sub),
              );
            },
          );
        }(),
      ),
    );
  }
}
