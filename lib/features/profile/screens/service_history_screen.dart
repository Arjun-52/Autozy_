import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/daily_service_provider.dart';
import '../../../providers/vehicle_provider.dart';
import '../../../data/models/dto/service_history_response.dart';

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
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Service History",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "${vehicle.brand} ${vehicle.model} (${vehicle.vehicleNumber})",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
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
            padding: const EdgeInsets.all(16),
            itemCount: provider.historyList.length + 1,
            itemBuilder: (context, index) {
              if (index == provider.historyList.length) {
                return provider.isPageLoading
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(
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
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  (item.serviceStatus ?? 'UNKNOWN').toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                formattedDate,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.serviceType ?? 'General Wash & Clean',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          if (item.specialistDetails != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  "Specialist: ${item.specialistDetails}",
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            ),
          ],
          if (item.completionInfo != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
                const SizedBox(width: 6),
                Text(
                  "Completed: ${item.completionInfo}",
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            ),
          ],
          if (item.notes != null && item.notes!.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 6),
            Text(
              "Notes: ${item.notes}",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
                fontStyle: FontStyle.italic,
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
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 80, height: 16, color: Colors.grey.shade200),
                    Container(width: 60, height: 16, color: Colors.grey.shade200),
                  ],
                ),
                const SizedBox(height: 16),
                Container(width: 150, height: 20, color: Colors.grey.shade200),
                const SizedBox(height: 12),
                Container(width: 200, height: 14, color: Colors.grey.shade200),
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
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 70, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              "No service history available",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "When your vehicle is cleaned or serviced, history will appear here.",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => provider.fetchHistory(widget.vehicleId),
              icon: const Icon(Icons.refresh),
              label: const Text("Refresh"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffF4C430),
                foregroundColor: Colors.black,
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
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 70, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage ?? "An error occurred while loading history.",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => provider.fetchHistory(widget.vehicleId),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text("Retry Connection", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
