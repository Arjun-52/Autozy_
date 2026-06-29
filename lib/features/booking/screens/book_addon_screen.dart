import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/navigation_service.dart';
import '../../../providers/vehicle_provider.dart';
import '../../../providers/area_provider.dart';
import '../../../providers/addon_booking_provider.dart';
import '../../../data/models/dto/book_addon_request_model.dart';
import '../../../data/models/dto/nearby_areas_response.dart';
import '../../../data/models/dto/addon_slots_response_model.dart';

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
  AddonSlotModel? _selectedSlot;

  // Add-on Services static options matching backend ID format
  final List<Map<String, String>> _addonServices = [
    {
      'id': 'a29699e8-8830-42ab-822f-239da02eab42',
      'name': 'Deep Interior Cleaning',
      'description': 'Thorough cleaning of seats, mats, and dashboard.',
      'price': '₹1,499'
    },
    {
      'id': '8d5845d5-1f22-4e08-ad5b-318c3f3abe01',
      'name': 'Machine Wax Polish',
      'description': 'Premium wax coating for extra shine.',
      'price': '₹999'
    },
    {
      'id': '7e325e1b-be73-4335-8b74-dc7d81f17109',
      'name': 'Engine Bay Cleaning',
      'description': 'Safe cleaning of engine compartment.',
      'price': '₹999'
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleProvider>().fetchVehicles(page: 1, limit: 20, reset: true);
      context.read<AddonBookingProvider>().clearSlots();
      
      // Auto-select city from AreaProvider if available
      final areaProvider = context.read<AreaProvider>();
      if (areaProvider.selectedArea?.cityId != null) {
        setState(() {
          _selectedCityId = areaProvider.selectedArea!.cityId;
        });
      }
    });
  }

  void _fetchAvailableSlots() {
    if (_selectedAddonServiceId != null &&
        _selectedCityId != null &&
        _selectedDate != null) {
      context.read<AddonBookingProvider>().fetchSlots(
            addonServiceId: _selectedAddonServiceId!,
            cityId: _selectedCityId!,
            date: _formatDate(_selectedDate!),
          );
      setState(() {
        _selectedSlot = null;
      });
    }
  }



  Future<void> _pickDate() async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final picked = await showDatePicker(
      context: context,
      initialDate: tomorrow,
      firstDate: tomorrow,
      lastDate: tomorrow.add(const Duration(days: 30)),
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
      _fetchAvailableSlots();
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
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

    if (_selectedSlot == null) {
      _showSnackBar("Please select a time slot");
      return;
    }

    final request = BookAddonRequestModel(
      vehicleId: _selectedVehicleId!,
      addonServiceId: _selectedAddonServiceId!,
      scheduledDate: _formatDate(_selectedDate!),
      scheduledSlotStart: _selectedSlot!.start,
      scheduledSlotEnd: _selectedSlot!.end,
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
                  },
                ),
              ),
            const SizedBox(height: 20),

            // Addon Service Selection
            _buildSectionHeader("Select Add-on Service"),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _addonServices.length,
              itemBuilder: (context, index) {
                final service = _addonServices[index];
                final isSelected = _selectedAddonServiceId == service['id'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAddonServiceId = service['id'];
                    });
                    _fetchAvailableSlots();
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service['name']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                service['description']!,
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
                          service['price']!,
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
            ),
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
                  _fetchAvailableSlots();
                },
              ),
            ),
            const SizedBox(height: 20),

            // Date Picker Row
            _buildSectionHeader("Schedule Date"),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
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
            ),
            const SizedBox(height: 20),

            // Time Slots Selection
            if (_selectedDate != null &&
                _selectedCityId != null &&
                _selectedAddonServiceId != null) ...[
              _buildSectionHeader("Available Time Slots"),
              if (addonBookingProvider.isLoadingSlots)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: CircularProgressIndicator(color: AppColors.brandYellow),
                  ),
                )
              else if (addonBookingProvider.slotsError != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Failed to load slots: ${addonBookingProvider.slotsError}",
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _fetchAvailableSlots,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandYellow,
                          foregroundColor: Colors.black,
                        ),
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                )
              else if (addonBookingProvider.slots.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      "No slots available for the selected date. Please choose a different date.",
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.8,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: addonBookingProvider.slots.length,
                  itemBuilder: (context, index) {
                    final slot = addonBookingProvider.slots[index];
                    final isAvailable = slot.status.toLowerCase() == 'available';
                    final isSelected = _selectedSlot?.start == slot.start && _selectedSlot?.end == slot.end;

                    return GestureDetector(
                      onTap: isAvailable
                          ? () {
                              setState(() {
                                _selectedSlot = slot;
                              });
                            }
                          : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xffFFFDF0)
                              : (isAvailable ? Colors.white : Colors.grey.shade100),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.brandYellow
                                : (isAvailable ? Colors.grey.shade300 : Colors.grey.shade200),
                            width: isSelected ? 1.5 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${slot.start} - ${slot.end}",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isAvailable ? Colors.black87 : Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              slot.status,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isAvailable ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
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
