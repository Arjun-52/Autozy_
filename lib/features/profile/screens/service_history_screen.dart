import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/daily_service_provider.dart';
import '../../../providers/vehicle_provider.dart';
import '../../../data/models/dto/service_history_response.dart';
import '../../../core/utils/responsive.dart';

class ServiceHistoryScreen extends StatefulWidget {
  final String vehicleId;

  const ServiceHistoryScreen({super.key, required this.vehicleId});

  @override
  State<ServiceHistoryScreen> createState() => _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends State<ServiceHistoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DailyServiceProvider>().fetchHistory(widget.vehicleId);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<DailyServiceProvider>().loadMore(widget.vehicleId);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = context.watch<VehicleProvider>();
    final dailyProvider = context.watch<DailyServiceProvider>();

    // Find vehicle info
    final vehicle = vehicleProvider.vehicles.firstWhere(
      (v) => v.id == widget.vehicleId,
      orElse: () => vehicleProvider.vehicles.isNotEmpty 
          ? vehicleProvider.vehicles.first 
          : throw Exception("Vehicle not found"),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Service History",
              style: TextStyle(
                color: Colors.black,
                fontSize: context.sp(15),
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "${vehicle.brand} ${vehicle.model} (${vehicle.vehicleNumber})",
              style: TextStyle(
                color: Colors.grey,
                fontSize: context.sp(11.5),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _buildBody(dailyProvider),
    );
  }

  Widget _buildBody(DailyServiceProvider provider) {
    switch (provider.status) {
      case DailyServiceHistoryStatus.initial:
      case DailyServiceHistoryStatus.loading:
        return _buildShimmerLoading();
      case DailyServiceHistoryStatus.empty:
        return _buildEmptyState(provider);
      case DailyServiceHistoryStatus.error:
        return _buildErrorState(provider);
      case DailyServiceHistoryStatus.success:
        return RefreshIndicator(
          color: const Color(0xffC68A00),
          onRefresh: () => provider.fetchHistory(widget.vehicleId, isRefresh: true),
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(context.w(16)),
            itemCount: provider.historyList.length + 1,
            itemBuilder: (context, index) {
              if (index == provider.historyList.length) {
                return provider.isPageLoading
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: context.h(24)),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xffF4C430),
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
              }
              return _buildHistoryCard(provider.historyList[index]);
            },
          ),
        );
    }
  }

  Widget _buildHistoryCard(ServiceHistoryModel item) {
    final statusColor = _getStatusColor(item.serviceStatus ?? 'pending');
    final formattedDate = _formatDate(item.serviceDate ?? '');

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: context.w(8), vertical: context.h(4)),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  (item.serviceStatus ?? 'UNKNOWN').toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: context.sp(10),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                formattedDate,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: context.sp(11.5),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(8)),
          Text(
            item.serviceType ?? 'General Wash & Clean',
            style: TextStyle(
              fontSize: context.sp(14),
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          if (item.specialistDetails != null) ...[
            SizedBox(height: context.h(8)),
            Row(
              children: [
                Icon(Icons.person_outline, size: 14, color: Colors.grey.shade500),
                SizedBox(width: context.w(6)),
                Text(
                  "Specialist: ${item.specialistDetails}",
                  style: TextStyle(color: Colors.black54, fontSize: context.sp(12), fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
          if (item.completionInfo != null) ...[
            SizedBox(height: context.h(6)),
            Row(
              children: [
                const Icon(Icons.check_circle_outline, size: 14, color: Colors.green),
                SizedBox(width: context.w(6)),
                Text(
                  "Completed: ${item.completionInfo}",
                  style: TextStyle(color: Colors.black54, fontSize: context.sp(12), fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
          if (item.notes != null && item.notes!.isNotEmpty) ...[
            SizedBox(height: context.h(10)),
            const Divider(),
            SizedBox(height: context.h(6)),
            Text(
              "Notes: ${item.notes}",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: context.sp(11.5),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'done':
      case 'success':
        return Colors.green;
      case 'in_progress':
      case 'active':
      case 'cleaning':
        return Colors.blue;
      case 'pending':
      case 'scheduled':
        return Colors.orange;
      case 'cancelled':
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(dateStr).toLocal();
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return "${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}";
    } catch (_) {
      return dateStr;
    }
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: EdgeInsets.all(context.w(16)),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: context.h(12)),
          height: context.h(120),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE9E9E9)),
          ),
          child: Padding(
            padding: EdgeInsets.all(context.w(11)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: context.w(80), height: context.h(16), color: Colors.grey.shade200),
                    Container(width: context.w(60), height: context.h(16), color: Colors.grey.shade200),
                  ],
                ),
                SizedBox(height: context.h(16)),
                Container(width: context.w(150), height: context.h(20), color: Colors.grey.shade200),
                SizedBox(height: context.h(12)),
                Container(width: context.w(200), height: context.h(14), color: Colors.grey.shade200),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(DailyServiceProvider provider) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.w(32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: context.w(64), color: Colors.grey.shade400),
            SizedBox(height: context.h(16)),
            Text(
              "No service history available",
              style: TextStyle(
                fontSize: context.sp(14),
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(8)),
            Text(
              "When your vehicle is cleaned or serviced, history will appear here.",
              style: TextStyle(
                fontSize: context.sp(12.5),
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(24)),
            ElevatedButton.icon(
              onPressed: () => provider.fetchHistory(widget.vehicleId),
              icon: Icon(Icons.refresh, size: context.w(18)),
              label: Text("Refresh", style: TextStyle(fontSize: context.sp(13), fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffF4C430),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(DailyServiceProvider provider) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.w(32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: context.w(64), color: Colors.redAccent),
            SizedBox(height: context.h(16)),
            Text(
              provider.errorMessage ?? "An error occurred while loading history.",
              style: TextStyle(
                fontSize: context.sp(13.5),
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(24)),
            ElevatedButton(
              onPressed: () => provider.fetchHistory(widget.vehicleId),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text("Retry Connection", style: TextStyle(color: Colors.white, fontSize: context.sp(13), fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
