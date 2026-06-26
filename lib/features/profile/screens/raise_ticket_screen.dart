import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/utils/responsive.dart';
import '../../../providers/ticket_provider.dart';
import '../../../providers/vehicle_provider.dart';
import '../../../providers/subscription_provider.dart';

class RaiseTicketScreen extends StatefulWidget {
  const RaiseTicketScreen({super.key});

  @override
  State<RaiseTicketScreen> createState() => _RaiseTicketScreenState();
}

class _RaiseTicketScreenState extends State<RaiseTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String? _selectedType;
  String? _selectedVehicleId;
  String? _selectedSubscriptionId;
  DateTime? _selectedServiceDate;
  final List<String> _localPhotoPaths = [];

  final List<String> _ticketTypes = [
    'MISSED_SERVICE',
    'QUALITY_ISSUE',
    'BILLING',
    'OTHER',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleProvider>().fetchVehicles(reset: true);
      context.read<SubscriptionProvider>().fetchSubscriptions();
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: context.h(12)),
              Text(
                "Attach Proof Photo",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: context.sp(15)),
              ),
              SizedBox(height: context.h(12)),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: Colors.black87),
                title: const Text("Take Photo", style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: Colors.black87),
                title: const Text("Choose from Gallery", style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              SizedBox(height: context.h(12)),
            ],
          ),
        );
      },
    );

    if (source != null) {
      try {
        final XFile? file = await _picker.pickImage(
          imageQuality: 75,
          maxWidth: 1200,
          source: source,
        );
        if (!mounted || !context.mounted) return;
        if (file != null) {
          setState(() {
            _localPhotoPaths.add(file.path);
          });
        }
      } catch (e) {
        if (!mounted || !context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  Future<void> _selectDate() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today.subtract(const Duration(days: 30)),
      lastDate: today,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xffF4C430),
              onPrimary: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (!mounted || !context.mounted) return;

    if (picked != null) {
      setState(() {
        _selectedServiceDate = picked;
      });
    }
  }

  Future<void> _submitTicket() async {
    if (!_formKey.currentState!.validate()) return;

    final isServiceTicket = _selectedType == 'MISSED_SERVICE' || _selectedType == 'QUALITY_ISSUE';
    if (isServiceTicket) {
      if (_selectedSubscriptionId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An active subscription is required for this ticket type')),
        );
        return;
      }
      if (_selectedServiceDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service date is required for this ticket type')),
        );
        return;
      }
    }

    try {
      final ticketProvider = context.read<TicketProvider>();
      final created = await ticketProvider.createTicket(
        type: _selectedType!,
        vehicleId: _selectedVehicleId!,
        subscriptionId: _selectedSubscriptionId,
        serviceDate: _selectedServiceDate != null
            ? DateTime.utc(_selectedServiceDate!.year, _selectedServiceDate!.month, _selectedServiceDate!.day).toIso8601String()
            : null,
        description: _descriptionController.text,
        localPhotoPaths: _localPhotoPaths,
      );

      if (!mounted || !context.mounted) return;

      if (created != null) {
        _showSuccessDialog(created.id ?? '', created.status ?? 'OPEN', created.createdAt ?? '');
      }
    } catch (e) {
      if (!mounted || !context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.redAccent),
      );
    }
  }

  void _showSuccessDialog(String ticketId, String status, String createdDate) {
    String formattedDate = createdDate;
    try {
      final dt = DateTime.parse(createdDate).toLocal();
      formattedDate = "${dt.day}/${dt.month}/${dt.year}";
    } catch (_) {}

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text("Success", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Ticket Submitted Successfully",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                const SizedBox(height: 16),
                _buildPopupRow("Ticket ID", ticketId),
                _buildPopupRow("Status", status),
                _buildPopupRow("Created Date", formattedDate),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx); // Close dialog
                  context.replace('/ticket-details/$ticketId'); // Navigate to details
                },
                child: const Text(
                  "View Details",
                  style: TextStyle(color: Color(0xffC68A00), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPopupRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = context.watch<VehicleProvider>();
    final subscriptionProvider = context.watch<SubscriptionProvider>();
    final ticketProvider = context.watch<TicketProvider>();

    final vehicles = vehicleProvider.vehicles;
    final subscriptions = subscriptionProvider.subscriptions;

    // Filter subscriptions for the selected vehicle
    final filteredSubscriptions = subscriptions
        .where((sub) => sub.vehicle?.id == _selectedVehicleId)
        .toList();

    final isDateReq = _selectedType == 'MISSED_SERVICE' || _selectedType == 'QUALITY_ISSUE';

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Raise Ticket",
          style: TextStyle(
            color: Colors.black,
            fontSize: context.sp(16),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(context.w(16)),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type selection dropdown
                  _buildSectionTitle("Ticket Type"),
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    isExpanded: true,
                    style: TextStyle(fontSize: context.sp(13.5), color: Colors.black),
                    decoration: _buildInputDecoration("Select Ticket Type"),
                    items: _ticketTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                type.replaceAll('_', ' '),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedType = val;
                      });
                    },
                    validator: (val) => val == null ? 'Please select ticket type' : null,
                  ),
                  SizedBox(height: context.h(16)),

                  // Vehicle dropdown
                  _buildSectionTitle("Vehicle Selection"),
                  DropdownButtonFormField<String>(
                    value: _selectedVehicleId,
                    isExpanded: true,
                    style: TextStyle(fontSize: context.sp(13.5), color: Colors.black),
                    decoration: _buildInputDecoration(
                      vehicleProvider.isListLoading
                          ? "Loading vehicles..."
                          : (vehicles.isEmpty
                              ? "No vehicles found"
                              : "Select Vehicle"),
                    ),
                    items: vehicles.map((v) {
                      return DropdownMenuItem<String>(
                        value: v.id,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${v.brand} ${v.model} (${v.vehicleNumber})",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: vehicleProvider.isListLoading || vehicles.isEmpty
                        ? null
                        : (val) {
                            setState(() {
                              _selectedVehicleId = val;
                              _selectedSubscriptionId = null; // Reset sub choice
                            });
                          },
                    validator: (val) => val == null ? 'Please select a vehicle' : null,
                  ),
                  SizedBox(height: context.h(16)),

                  // Sub dropdown (if vehicle chosen and sub exists)
                  if (_selectedVehicleId != null) ...[
                    _buildSectionTitle("Subscription Selection"),
                    DropdownButtonFormField<String>(
                      value: _selectedSubscriptionId,
                      isExpanded: true,
                      style: TextStyle(fontSize: context.sp(13.5), color: Colors.black),
                      decoration: _buildInputDecoration(
                        subscriptionProvider.isListLoading
                            ? "Loading subscriptions..."
                            : (filteredSubscriptions.isEmpty
                                ? "No subscriptions active for this vehicle"
                                : "Select Subscription"),
                      ),
                      items: filteredSubscriptions.map((s) {
                        return DropdownMenuItem<String>(
                          value: s.id,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${s.planPricing?.plan?.name ?? 'Plan'} (${s.id.substring(0, 8)})",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: subscriptionProvider.isListLoading || filteredSubscriptions.isEmpty
                          ? null
                          : (val) {
                              setState(() {
                                _selectedSubscriptionId = val;
                              });
                            },
                    ),
                    SizedBox(height: context.h(16)),
                  ],

                  // Service date picker
                  if (isDateReq) ...[
                    _buildSectionTitle("Service Date"),
                    GestureDetector(
                      onTap: _selectDate,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: context.w(12), vertical: context.h(14)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE9E9E9)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedServiceDate == null
                                  ? "Choose Date"
                                  : "${_selectedServiceDate!.day}/${_selectedServiceDate!.month}/${_selectedServiceDate!.year}",
                              style: TextStyle(
                                fontSize: context.sp(13.5),
                                color: _selectedServiceDate == null ? Colors.grey : Colors.black,
                              ),
                            ),
                            Icon(Icons.calendar_today, size: context.w(18), color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: context.h(16)),
                  ],

                  // Description
                  _buildSectionTitle("Description"),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    maxLength: 2000,
                    style: TextStyle(fontSize: context.sp(13.5)),
                    buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
                      return Text(
                        "$currentLength / $maxLength",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: context.sp(11)),
                      );
                    },
                    decoration: InputDecoration(
                      hintText: "Enter ticket description here...",
                      hintStyle: TextStyle(fontSize: context.sp(13.5), color: Colors.grey),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE9E9E9)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE9E9E9)),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Description is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: context.h(16)),

                  // Attach Photos
                  _buildSectionTitle("Proof Photos (Optional)"),
                  Wrap(
                    spacing: context.w(10),
                    runSpacing: context.h(10),
                    children: [
                      ...List.generate(_localPhotoPaths.length, (idx) {
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(_localPhotoPaths[idx]),
                                width: context.w(72),
                                height: context.w(72),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 2,
                              right: 2,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _localPhotoPaths.removeAt(idx);
                                  });
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.close, color: Colors.white, size: context.w(16)),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: context.w(72),
                          height: context.w(72),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE9E9E9)),
                          ),
                          child: Icon(Icons.add_a_photo_outlined, color: Colors.grey, size: context.w(24)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(32)),

                  // Submit button
                  SizedBox(
  width: double.infinity,
  height: 48, // Use a fixed height first
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFFCB2F),
      elevation: 0,
      padding: EdgeInsets.zero,
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    onPressed: ticketProvider.isSubmitting ? null : _submitTicket,
    child: Center(
      child: Text(
        "Submit Ticket",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: context.sp(14),
          fontWeight: FontWeight.w600,
          height: 1.0,
        ),
      ),
    ),
  ),
),
                ],
              ),
            ),
          ),
          if (ticketProvider.isSubmitting)
            Container(
              color: Colors.black12,
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xffF4C430)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(6)),
      child: Text(
        title,
        style: TextStyle(fontSize: context.sp(13), fontWeight: FontWeight.w600, color: Colors.black87),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: context.sp(13.5), color: Colors.grey),
      fillColor: Colors.white,
      filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: context.w(12), vertical: context.h(14)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE9E9E9)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE9E9E9)),
      ),
    );
  }
}
