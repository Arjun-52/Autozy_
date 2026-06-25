import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/addon_booking_provider.dart';
import '../../../data/models/dto/my_addon_bookings_response.dart';
import '../../../core/utils/responsive.dart';

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
      backgroundColor: const Color(0xFFF9F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              context.pop();
            } else {
              context.go('/home?initialIndex=3');
            }
          },
        ),
        title: Text(
          "My Add-on Bookings",
          style: TextStyle(
            color: Colors.black,
            fontSize: context.sp(16),
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
            padding: EdgeInsets.all(context.w(16)),
            itemCount: provider.bookings.length + 1,
            itemBuilder: (context, index) {
              if (index == provider.bookings.length) {
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
          // Row 1: Booking ID & Status badge
          Row(
            children: [
              Expanded(
                child: Text(
                  "ID: ${booking.bookingId ?? booking.id ?? 'N/A'}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: context.sp(11.5),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(width: context.w(8)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: context.w(8), vertical: context.h(4)),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  (booking.status ?? 'PENDING').toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: context.sp(10),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(8)),

          // Row 2: Service name
          Text(
            booking.serviceName ?? "Wash & Clean Add-on",
            style: TextStyle(
              fontSize: context.sp(14),
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: context.h(2)),

          // Service category
          if (booking.serviceCategory != null)
            Text(
              "Category: ${booking.serviceCategory}",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: context.sp(11.5),
                fontWeight: FontWeight.w400,
              ),
            ),
          SizedBox(height: context.h(8)),
          const Divider(),
          SizedBox(height: context.h(8)),

          // Row 3: Vehicle details
          if (booking.vehicleDetails != null) ...[
            _buildInfoRow(Icons.directions_car, "Vehicle", _formatVehicleDetails(booking)),
            SizedBox(height: context.h(6)),
          ],

          // Row 4: Scheduled Date & Created/Booking Date
          if (formattedScheduledDate.isNotEmpty) ...[
            _buildInfoRow(Icons.calendar_month, "Scheduled Date", formattedScheduledDate),
            SizedBox(height: context.h(6)),
          ],
          if (formattedBookingDate.isNotEmpty) ...[
            _buildInfoRow(Icons.edit_calendar, "Booking Date", formattedBookingDate),
            SizedBox(height: context.h(6)),
          ],

          // Row 5: Price & Payment Status
          SizedBox(height: context.h(6)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                booking.amount != null ? "₹${booking.amount!.toStringAsFixed(2)}" : "₹0.00",
                style: TextStyle(
                  fontSize: context.sp(14),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xffC68A00),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: context.w(8), vertical: context.h(4)),
                decoration: BoxDecoration(
                  color: paymentStatusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  (booking.paymentStatus ?? 'pending').toUpperCase(),
                  style: TextStyle(
                    color: paymentStatusColor,
                    fontSize: context.sp(9.5),
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

  String _formatVehicleDetails(AddonBookingModel booking) {
    if (booking.rawJson != null) {
      final vehicleData = booking.rawJson!['vehicle'] ?? booking.rawJson!['vehicleDetails'];
      if (vehicleData is Map) {
        final brand = vehicleData['brand'] ?? '';
        final model = vehicleData['model'] ?? '';
        final vehicleNumber = vehicleData['vehicle_number'] ?? vehicleData['vehicleNumber'] ?? '';

        final parts = <String>[];
        if (brand.toString().isNotEmpty || model.toString().isNotEmpty) {
          parts.add('${brand} ${model}'.trim());
        }
        if (vehicleNumber.toString().isNotEmpty) {
          parts.add('($vehicleNumber)');
        }
        if (parts.isNotEmpty) {
          return parts.join(' ');
        }
      }
    }

    final details = booking.vehicleDetails;
    if (details != null && details.startsWith('{') && details.endsWith('}')) {
      try {
        final brandMatch = RegExp(r'brand:\s*([^,}]+)').firstMatch(details);
        final modelMatch = RegExp(r'model:\s*([^,}]+)').firstMatch(details);
        final numberMatch = RegExp(r'vehicle_number:\s*([^,}]+)').firstMatch(details) ??
                            RegExp(r'vehicleNumber:\s*([^,}]+)').firstMatch(details);

        final brand = brandMatch?.group(1)?.trim() ?? '';
        final model = modelMatch?.group(1)?.trim() ?? '';
        final vehicleNumber = numberMatch?.group(1)?.trim() ?? '';

        final parts = <String>[];
        if (brand.isNotEmpty || model.isNotEmpty) {
          parts.add('${brand} ${model}'.trim());
        }
        if (vehicleNumber.isNotEmpty) {
          parts.add('($vehicleNumber)');
        }
        if (parts.isNotEmpty) {
          return parts.join(' ');
        }
      } catch (_) {}
    }

    return booking.vehicleDetails ?? 'N/A';
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        SizedBox(width: context.w(6)),
        Text(
          "$label: ",
          style: TextStyle(color: Colors.grey.shade600, fontSize: context.sp(11.5), fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: Colors.black87, fontSize: context.sp(11.5), fontWeight: FontWeight.w500),
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
      padding: EdgeInsets.all(context.w(16)),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: context.h(12)),
          height: context.h(160),
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
                    Container(width: context.w(100), height: context.h(14), color: Colors.grey.shade100),
                    Container(width: context.w(80), height: context.h(20), color: Colors.grey.shade100),
                  ],
                ),
                SizedBox(height: context.h(16)),
                Container(width: context.w(180), height: context.h(22), color: Colors.grey.shade100),
                SizedBox(height: context.h(16)),
                const Divider(),
                SizedBox(height: context.h(12)),
                Container(width: context.w(140), height: context.h(14), color: Colors.grey.shade100),
                SizedBox(height: context.h(8)),
                Container(width: context.w(200), height: context.h(14), color: Colors.grey.shade100),
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
        padding: EdgeInsets.all(context.w(32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: context.w(64), color: Colors.grey.shade400),
            SizedBox(height: context.h(16)),
            Text(
              "No add-on bookings found",
              style: TextStyle(
                fontSize: context.sp(14),
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(24)),
            ElevatedButton.icon(
              onPressed: () => provider.fetchBookings(),
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

  Widget _buildErrorState(AddonBookingProvider provider) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.w(32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: context.w(64), color: Colors.redAccent),
            SizedBox(height: context.h(16)),
            Text(
              provider.errorMessage ?? "An error occurred while loading bookings.",
              style: TextStyle(
                fontSize: context.sp(13.5),
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(24)),
            ElevatedButton(
              onPressed: () => provider.fetchBookings(),
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
