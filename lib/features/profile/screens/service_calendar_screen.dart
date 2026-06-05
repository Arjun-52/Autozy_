import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/daily_calendar_provider.dart';
import '../../../providers/vehicle_provider.dart';
import '../../../data/models/dto/service_calendar_response.dart';

class ServiceCalendarScreen extends StatefulWidget {
  final String vehicleId;

  const ServiceCalendarScreen({super.key, required this.vehicleId});

  @override
  State<ServiceCalendarScreen> createState() => _ServiceCalendarScreenState();
}

class _ServiceCalendarScreenState extends State<ServiceCalendarScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DailyCalendarProvider>().fetchCalendar(widget.vehicleId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = context.watch<VehicleProvider>();
    final calendarProvider = context.watch<DailyCalendarProvider>();

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
              "Service Calendar",
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
      body: _buildBody(calendarProvider),
    );
  }

  Widget _buildBody(DailyCalendarProvider provider) {
    switch (provider.status) {
      case DailyServiceCalendarStatus.initial:
      case DailyServiceCalendarStatus.loading:
        return _buildShimmerLoading();
      case DailyServiceCalendarStatus.empty:
        return _buildEmptyState(provider);
      case DailyServiceCalendarStatus.error:
        return _buildErrorState(provider);
      case DailyServiceCalendarStatus.success:
        return RefreshIndicator(
          color: const Color(0xffC68A00),
          onRefresh: () => provider.fetchCalendar(widget.vehicleId, isRefresh: true),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildCalendarHeader(provider),
                _buildCalendarGrid(provider),
                _buildDayDetailsSection(provider),
              ],
            ),
          ),
        );
    }
  }

  Widget _buildCalendarHeader(DailyCalendarProvider provider) {
    final monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final displayMonth = monthNames[provider.selectedMonth - 1];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.black87),
            onPressed: () => provider.changeMonth(widget.vehicleId, false),
          ),
          Text(
            "$displayMonth ${provider.selectedYear}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.black87),
            onPressed: () => provider.changeMonth(widget.vehicleId, true),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(DailyCalendarProvider provider) {
    final year = provider.selectedYear;
    final month = provider.selectedMonth;

    final firstDayOfMonth = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final startWeekday = firstDayOfMonth.weekday; // 1 = Monday, 7 = Sunday

    // Align grid starting with Sunday (Sunday = 0, Monday = 1, ..., Saturday = 6)
    final startOffset = startWeekday == 7 ? 0 : startWeekday;

    final weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Weekday header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekdays.map((day) => Expanded(
              child: Center(
                child: Text(
                  day,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 12),
          // Month days grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: daysInMonth + startOffset,
            itemBuilder: (context, index) {
              if (index < startOffset) {
                return const SizedBox.shrink();
              }

              final dayNum = index - startOffset + 1;
              final dayKey = dayNum.toString();
              final hasService = provider.calendarData?.days.containsKey(dayKey) ?? false;
              final serviceDetails = hasService ? provider.calendarData!.days[dayKey] : null;

              final isSelected = provider.selectedDayKey == dayKey;

              return GestureDetector(
                onTap: hasService ? () => provider.selectDay(dayKey) : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? const Color(0xffFFFBF0) 
                        : (hasService ? Colors.grey.shade50 : Colors.transparent),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected 
                          ? const Color(0xffF4C430) 
                          : (hasService ? Colors.grey.shade200 : Colors.transparent),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dayKey,
                          style: TextStyle(
                            fontWeight: hasService ? FontWeight.bold : FontWeight.normal,
                            color: hasService ? Colors.black87 : Colors.grey.shade400,
                            fontSize: 14,
                          ),
                        ),
                        if (hasService && serviceDetails != null) ...[
                          const SizedBox(height: 4),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _getStatusIndicatorColor(serviceDetails.status ?? 'pending'),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDayDetailsSection(DailyCalendarProvider provider) {
    if (provider.selectedDayKey == null || provider.selectedDayDetails == null) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            "Select a marked day to view service details",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
      );
    }

    final ServiceCalendarDayModel details = provider.selectedDayDetails!;
    final statusColor = _getStatusIndicatorColor(details.status ?? 'pending');

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
              Text(
                "Day ${provider.selectedDayKey} Details",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  (details.status ?? 'pending').toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow(Icons.cleaning_services, "Service Type", details.serviceType ?? "General cleaning"),
          if (details.time != null) ...[
            const SizedBox(height: 12),
            _buildDetailRow(Icons.access_time, "Scheduled Time", details.time!),
          ],
          if (details.specialist != null) ...[
            const SizedBox(height: 12),
            _buildDetailRow(Icons.person_outline, "Specialist Assigned", details.specialist!),
          ],
          if (details.notes != null && details.notes!.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              "Specialist Notes",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              details.notes!,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13, fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusIndicatorColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'done':
        return Colors.green;
      case 'missed':
      case 'failed':
        return Colors.red;
      case 'upcoming':
      case 'scheduled':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  Widget _buildShimmerLoading() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 30, height: 30, color: Colors.grey.shade100),
              Container(width: 120, height: 24, color: Colors.grey.shade100),
              Container(width: 30, height: 30, color: Colors.grey.shade100),
            ],
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: 35,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(DailyCalendarProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined, size: 70, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              "No services scheduled for this month",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => provider.fetchCalendar(widget.vehicleId),
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

  Widget _buildErrorState(DailyCalendarProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 70, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage ?? "An error occurred while loading calendar.",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => provider.fetchCalendar(widget.vehicleId),
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
