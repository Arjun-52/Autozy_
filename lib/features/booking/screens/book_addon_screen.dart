import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/navigation_service.dart';
import '../../../providers/vehicle_provider.dart';
import '../../../providers/area_provider.dart';
import '../../../providers/addon_booking_provider.dart';
import '../../../data/models/dto/book_addon_request_model.dart';
import '../../../data/models/dto/nearby_areas_response.dart';

class BookAddonScreen extends StatefulWidget {
  const BookAddonScreen({super.key});

  @override
  State<BookAddonScreen> createState() => _BookAddonScreenState();
}

class _BookAddonScreenState extends State<BookAddonScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedVehicleId;
  String? _selectedAddonServiceId;
  String? _selectedCityId;
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleProvider>().fetchVehicles(page: 1, limit: 20, reset: true);

      // Auto-select city from AreaProvider if available
      final areaProvider = context.read<AreaProvider>();
      if (areaProvider.selectedArea?.cityId != null) {
        setState(() {
          _selectedCityId = areaProvider.selectedArea!.cityId;
        });
        _fetchServicesIfReady();
      }
    });
  }

  /// Loads the live add-on services catalog once both a vehicle (for its size)
  /// and a city are selected. Clears the current selection since pricing and
  /// availability are city/size-specific.
  void _fetchServicesIfReady() {
    final cityId = _selectedCityId;
    final vehicleId = _selectedVehicleId;
    if (cityId == null || vehicleId == null) return;

    final vehicleProvider = context.read<VehicleProvider>();
    final matches = vehicleProvider.vehicles.where((v) => v.id == vehicleId);
    if (matches.isEmpty) return;
    final size = matches.first.sizeCategory;
    if (size.isEmpty) return;

    setState(() {
      _selectedAddonServiceId = null;
    });
    context.read<AddonBookingProvider>().fetchServices(
          cityId: cityId,
          vehicleSize: size,
        );
  }

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: today.add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.brandYellow,
              onPrimary: Colors.black,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.brandYellow,
              onPrimary: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startTime = picked;
        // Auto-set end time to 1 hour later if not set
        if (_endTime == null) {
          final nextHour = (picked.hour + 1) % 24;
          _endTime = TimeOfDay(hour: nextHour, minute: picked.minute);
        }
      });
    }
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime != null
          ? TimeOfDay(hour: (_startTime!.hour + 1) % 24, minute: _startTime!.minute)
          : const TimeOfDay(hour: 10, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.brandYellow,
              onPrimary: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  String _formatTime(TimeOfDay time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00";
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedVehicleId == null) {
      _showSnackBar("Please select a vehicle");
      return;
    }

    if (_selectedAddonServiceId == null) {
      _showSnackBar("Please select an add-on service");
      return;
    }

    if (_selectedCityId == null) {
      _showSnackBar("Please select a city");
      return;
    }

    if (_selectedDate == null) {
      _showSnackBar("Please select a scheduled date");
      return;
    }

    if (_startTime == null || _endTime == null) {
      _showSnackBar("Please select start and end time slots");
      return;
    }

    // Verify start time is before end time
    final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
    final endMinutes = _endTime!.hour * 60 + _endTime!.minute;
    if (endMinutes <= startMinutes) {
      _showSnackBar("End time must be after start time");
      return;
    }

    final request = BookAddonRequestModel(
      vehicleId: _selectedVehicleId!,
      addonServiceId: _selectedAddonServiceId!,
      scheduledDate: _formatDate(_selectedDate!),
      scheduledSlotStart: _formatTime(_startTime!),
      scheduledSlotEnd: _formatTime(_endTime!),
      cityId: _selectedCityId!,
    );

    final provider = context.read<AddonBookingProvider>();
    final success = await provider.bookAddon(request);

    if (success && mounted) {
      _showSuccessDialog();
    } else if (mounted) {
      _showErrorDialog(provider.bookingError ?? "Failed to book service. Please try again.");
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (_) {
      NavigationService.scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _showSuccessDialog() {
    final lastBooking = context.read<AddonBookingProvider>().lastBookedAddon;
    if (lastBooking == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Booking Confirmed!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                _buildDialogInfoRow("Booking ID", lastBooking.id ?? "N/A"),
                _buildDialogInfoRow("Status", lastBooking.status ?? "ASSIGNED"),
                _buildDialogInfoRow("Date", lastBooking.scheduledDate ?? "N/A"),
                _buildDialogInfoRow(
                  "Time Slot",
                  "${lastBooking.scheduledSlotStart ?? 'N/A'} - ${lastBooking.scheduledSlotEnd ?? 'N/A'}",
                ),
                if (lastBooking.disputeWindowEnd != null)
                  _buildDialogInfoRow("Dispute Window End", _formatDateTimeString(lastBooking.disputeWindowEnd!)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      context.read<AddonBookingProvider>().clearBookingState();
                      context.go('/addon-bookings'); // Redirect to My Add-on Bookings list
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Go to My Bookings"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.redAccent),
              SizedBox(width: 8),
              Text("Booking Failed"),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  String _formatDateTimeString(String dtStr) {
    try {
      final dt = DateTime.parse(dtStr).toLocal();
      return "${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return dtStr;
    }
  }

  Widget _buildDialogInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = context.watch<VehicleProvider>();
    final areaProvider = context.watch<AreaProvider>();
    final addonProvider = context.watch<AddonBookingProvider>();
    final addonBookingProvider = context.watch<AddonBookingProvider>();

    // Generate city list based on areas loaded, ensuring unique city IDs
    final Map<String, AreaCity> uniqueCities = {};
    if (areaProvider.selectedArea?.city != null) {
      uniqueCities[areaProvider.selectedArea!.city!.id] = areaProvider.selectedArea!.city!;
    }
    for (var area in areaProvider.nearbyAreas) {
      if (area.city != null) {
        uniqueCities[area.city!.id] = area.city!;
      }
    }
    final cities = uniqueCities.values.toList();

    // Prevent assertion error if selected city ID is not in the list of unique cities
    if (_selectedCityId != null && !uniqueCities.containsKey(_selectedCityId)) {
      _selectedCityId = null;
    }

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        title: const Text(
          "Book Premium Add-on",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Vehicle Selection
            _buildSectionHeader("Select Vehicle"),
            if (vehicleProvider.isListLoading)
              _buildShimmerDropdown()
            else if (vehicleProvider.vehicles.isEmpty)
              _buildEmptyVehiclesWidget()
            else
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(border: InputBorder.none),
                  hint: const Text("Select your vehicle"),
                  value: _selectedVehicleId,
                  items: vehicleProvider.vehicles.map((v) {
                    return DropdownMenuItem<String>(
                      value: v.id,
                      child: Text("${v.brand} ${v.model} (${v.vehicleNumber})"),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedVehicleId = val;
                    });
                    _fetchServicesIfReady();
                  },
                ),
              ),
            const SizedBox(height: 20),

            // Addon Service Selection
            _buildSectionHeader("Select Add-on Service"),
            _buildAddonServiceList(addonProvider),
            const SizedBox(height: 12),

            // City Selection
            _buildSectionHeader("Select City"),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(border: InputBorder.none),
                hint: const Text("Select city"),
                value: _selectedCityId,
                items: cities.map((c) {
                  return DropdownMenuItem<String>(
                    value: c.id,
                    child: Text("${c.name}, ${c.state}"),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedCityId = val;
                  });
                  _fetchServicesIfReady();
                },
              ),
            ),
            const SizedBox(height: 20),

            // Date & Time Picker Row
            _buildSectionHeader("Schedule Date & Time"),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  // Date selection row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.calendar_month, color: Colors.black54),
                          SizedBox(width: 8),
                          Text(
                            "Date",
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: _pickDate,
                        child: Text(
                          _selectedDate == null
                              ? "Choose Date"
                              : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                          style: const TextStyle(
                            color: Color(0xffC68A00),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  // Start time row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.access_time, color: Colors.black54),
                          SizedBox(width: 8),
                          Text(
                            "Start Time Slot",
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: _pickStartTime,
                        child: Text(
                          _startTime == null ? "Select Start Time" : _startTime!.format(context),
                          style: const TextStyle(
                            color: Color(0xffC68A00),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  // End time row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.access_time_filled, color: Colors.black54),
                          SizedBox(width: 8),
                          Text(
                            "End Time Slot",
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: _pickEndTime,
                        child: Text(
                          _endTime == null ? "Select End Time" : _endTime!.format(context),
                          style: const TextStyle(
                            color: Color(0xffC68A00),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            addonBookingProvider.isBooking
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.brandYellow),
                  )
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandYellow,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Confirm & Book",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAddonServiceList(AddonBookingProvider addonProvider) {
    // Prompt to pick vehicle + city first (both needed to price services).
    if (_selectedVehicleId == null || _selectedCityId == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          "Select a vehicle and city to see available add-on services.",
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
      );
    }

    if (addonProvider.isServicesLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator(color: AppColors.brandYellow)),
      );
    }

    if (addonProvider.servicesError != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFECEC),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          addonProvider.servicesError!,
          style: const TextStyle(fontSize: 13, color: Colors.red),
        ),
      );
    }

    final services = addonProvider.services;
    if (services.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          "No add-on services available for this vehicle in the selected city.",
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        final isSelected = _selectedAddonServiceId == service.id;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedAddonServiceId = service.id;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xffFFFDF0) : Colors.white,
              border: Border.all(
                color: isSelected ? AppColors.brandYellow : Colors.transparent,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (service.imageUrl != null && service.imageUrl!.isNotEmpty) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: service.imageUrl!,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 52,
                        height: 52,
                        color: const Color(0xFFF2F2F2),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 52,
                        height: 52,
                        color: const Color(0xFFF2F2F2),
                        child: Icon(Icons.local_car_wash, color: Colors.grey.shade400),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        service.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  service.priceLabel,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffC68A00),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildShimmerDropdown() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.brandYellow, strokeWidth: 2),
      ),
    );
  }

  Widget _buildEmptyVehiclesWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("No vehicles registered"),
          TextButton(
            onPressed: () => context.pushNamed('addVehicle'),
            child: const Text(
              "Add Vehicle",
              style: TextStyle(color: Color(0xffC68A00), fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
