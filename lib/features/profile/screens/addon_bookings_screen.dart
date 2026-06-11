import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/addon_booking_provider.dart';
import '../../../data/models/dto/my_addon_bookings_response.dart';
import '../../../core/utils/price_utils.dart';

class AddonBookingsScreen extends StatefulWidget {
  const AddonBookingsScreen({super.key});

  @override
  State<AddonBookingsScreen> createState() => _AddonBookingsScreenState();
}

class _AddonBookingsScreenState extends State<AddonBookingsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddonBookingProvider>().fetchBookings();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<AddonBookingProvider>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AddonBookingProvider>();

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "My Add-on Bookings",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(AddonBookingProvider provider) {
    switch (provider.status) {
      case AddonBookingStatus.initial:
      case AddonBookingStatus.loading:
        return _buildShimmerLoading();
      case AddonBookingStatus.empty:
        return _buildEmptyState(provider);
      case AddonBookingStatus.error:
        return _buildErrorState(provider);
      case AddonBookingStatus.success:
        return RefreshIndicator(
          color: const Color(0xffC68A00),
          onRefresh: () => provider.fetchBookings(isRefresh: true),
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: provider.bookings.length + 1,
            itemBuilder: (context, index) {
              if (index == provider.bookings.length) {
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
              return _buildBookingCard(provider.bookings[index]);
            },
          ),
        );
    }
  }

  Widget _buildBookingCard(AddonBookingModel booking) {
    final statusColor = _getStatusColor(booking.status ?? 'pending');
    final paymentStatusColor = _getPaymentStatusColor(booking.paymentStatus ?? 'pending');
    final formattedBookingDate = _formatDate(booking.bookingDate ?? booking.createdAt ?? '');
    final formattedScheduledDate = _formatDate(booking.scheduledDate ?? '');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
          // Row 1: Booking ID & Status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ID: ${booking.bookingId ?? booking.id ?? 'N/A'}",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  (booking.status ?? 'PENDING').toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Row 2: Service name
          Text(
            booking.serviceName ?? "Wash & Clean Add-on",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),

          // Service category
          if (booking.serviceCategory != null)
            Text(
              "Category: ${booking.serviceCategory}",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),

          // Row 3: Vehicle details
          if (booking.vehicleDetails != null) ...[
            _buildInfoRow(Icons.directions_car, "Vehicle", booking.vehicleDetails!),
            const SizedBox(height: 8),
          ],

          // Row 4: Scheduled Date & Created/Booking Date
          if (formattedScheduledDate.isNotEmpty) ...[
            _buildInfoRow(Icons.calendar_month, "Scheduled Date", formattedScheduledDate),
            const SizedBox(height: 8),
          ],
          if (formattedBookingDate.isNotEmpty) ...[
            _buildInfoRow(Icons.edit_calendar, "Booking Date", formattedBookingDate),
            const SizedBox(height: 8),
          ],

          // Row 5: Price & Payment Status
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatCurrency(booking.amount, fractionDigits: 2),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffC68A00),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: paymentStatusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  (booking.paymentStatus ?? 'pending').toUpperCase(),
                  style: TextStyle(
                    color: paymentStatusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade500),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'CONFIRMED':
        return Colors.blue;
      case 'IN_PROGRESS':
        return Colors.purple;
      case 'COMPLETED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.grey;
      case 'FAILED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getPaymentStatusColor(String paymentStatus) {
    switch (paymentStatus.toLowerCase()) {
      case 'paid':
      case 'completed':
      case 'success':
        return Colors.green;
      case 'failed':
      case 'unpaid':
        return Colors.red;
      default:
        return Colors.orange;
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
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 100, height: 14, color: Colors.grey.shade100),
                    Container(width: 80, height: 20, color: Colors.grey.shade100),
                  ],
                ),
                const SizedBox(height: 16),
                Container(width: 180, height: 22, color: Colors.grey.shade100),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                Container(width: 140, height: 14, color: Colors.grey.shade100),
                const SizedBox(height: 8),
                Container(width: 200, height: 14, color: Colors.grey.shade100),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(AddonBookingProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 70, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              "No add-on bookings found",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => provider.fetchBookings(),
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

  Widget _buildErrorState(AddonBookingProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 70, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage ?? "An error occurred while loading bookings.",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => provider.fetchBookings(),
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
