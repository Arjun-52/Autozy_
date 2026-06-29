import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/app_logger.dart';
import '../../../data/models/dto/update_vehicle_request.dart';
import '../../../providers/vehicle_provider.dart';
import '../../../providers/auth_provider.dart';

class EditVehicleScreen extends StatefulWidget {
  final String vehicleId;
  const EditVehicleScreen({Key? key, required this.vehicleId}) : super(key: key);

  @override
  State<EditVehicleScreen> createState() => _EditVehicleScreenState();
}

class _EditVehicleScreenState extends State<EditVehicleScreen> {
  File? _newVehicleImageFile;
  String? _existingVehicleImageUrl;
  bool _imageRemoved = false;

  final numberController = TextEditingController();
  final sizeController = TextEditingController();
  final latController = TextEditingController();
  final lngController = TextEditingController();
  final notesController = TextEditingController();

  final numberFocus = FocusNode();
  final latFocus = FocusNode();
  final lngFocus = FocusNode();
  final notesFocus = FocusNode();

  String? selectedMake;
  String? selectedModel;
  String? selectedSize;

  final Map<String, List<String>> carModels = {
    "Hyundai": ["Creta", "i20", "Verna"],
    "Honda": ["City", "Civic"],
    "Toyota": ["Innova", "Fortuner"],
  };

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadVehicle();
  }

  Future<void> _loadVehicle() async {
    setState(() => _isLoading = true);
    try {
      final provider = context.read<VehicleProvider>();
      final vehicle = await provider.getVehicleById(widget.vehicleId);
      // Populate fields
      numberController.text = vehicle.vehicleNumber ?? '';
      sizeController.text = vehicle.sizeCategory ?? '';
      selectedMake = vehicle.brand;
      selectedModel = vehicle.model;
      selectedSize = vehicle.sizeCategory;
      latController.text = vehicle.parkingLocationLat?.toString() ?? '';
      lngController.text = vehicle.parkingLocationLng?.toString() ?? '';
      notesController.text = vehicle.parkingNotes ?? '';
      _existingVehicleImageUrl = vehicle.vehicleImage ?? vehicle.imageUrl;
    } catch (e) {
      AppLogger.error('Failed to load vehicle for edit', tag: 'Vehicles', error: e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 75,
        maxWidth: 1080,
        maxHeight: 1080,
      );

      if (pickedFile == null) return;

      final file = File(pickedFile.path);
      setState(() {
        _newVehicleImageFile = file;
        _imageRemoved = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to pick image: $e"), backgroundColor: Colors.redAccent)
        );
      }
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    numberController.dispose();
    sizeController.dispose();
    latController.dispose();
    lngController.dispose();
    notesController.dispose();
    numberFocus.dispose();
    latFocus.dispose();
    lngFocus.dispose();
    notesFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = context.watch<VehicleProvider>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final authProvider = context.read<AuthProvider>();
    final navigator = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Vehicle'),
        backgroundColor: const Color(0xFFF6C431),
        foregroundColor: Colors.black,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Image Section
                  if (_newVehicleImageFile != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: FileImage(_newVehicleImageFile!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white.withOpacity(0.9),
                                  radius: 18,
                                  child: IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
                                    onPressed: _showImagePickerOptions,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                CircleAvatar(
                                  backgroundColor: Colors.white.withOpacity(0.9),
                                  radius: 18,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                                    onPressed: () {
                                      setState(() {
                                        _newVehicleImageFile = null;
                                        _imageRemoved = true;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (_existingVehicleImageUrl != null && _existingVehicleImageUrl!.isNotEmpty && !_imageRemoved)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CachedNetworkImage(
                              imageUrl: _existingVehicleImageUrl!,
                              width: double.infinity,
                              height: 180,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey.shade100,
                                child: const Center(child: CircularProgressIndicator()),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey.shade100,
                                child: const Icon(Icons.error),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white.withOpacity(0.9),
                                  radius: 18,
                                  child: IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
                                    onPressed: _showImagePickerOptions,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                CircleAvatar(
                                  backgroundColor: Colors.white.withOpacity(0.9),
                                  radius: 18,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                                    onPressed: () {
                                      setState(() {
                                        _imageRemoved = true;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: _showImagePickerOptions,
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_outlined, size: 40, color: Colors.grey.shade600),
                            const SizedBox(height: 8),
                            Text(
                              "Upload Vehicle Photo",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "JPG, JPEG, PNG up to 5 MB",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Vehicle Number (read‑only, cannot change)
                  buildField(
                    label: "Vehicle Number",
                    focusNode: null,
                    child: TextField(
                      controller: numberController,
                      enabled: false,
                      decoration: const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // MAKE
                  buildField(
                    label: "Select Make",
                    focusNode: null,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedMake,
                        hint: const Text("Select Make"),
                        isExpanded: true,
                        items: carModels.keys
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedMake = value;
                            selectedModel = null;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // MODEL
                  buildField(
                    label: "Select Model",
                    focusNode: null,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedModel,
                        hint: const Text("Select Model"),
                        isExpanded: true,
                        items: (carModels[selectedMake] ?? [])
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (value) {
                          setState(() => selectedModel = value);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // SIZE (read-only, cannot change)
                  buildField(
                    label: "Size Category",
                    focusNode: null,
                    child: TextField(
                      controller: sizeController,
                      enabled: false,
                      decoration: const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // LATITUDE
                  buildField(
                    label: "Parking Latitude",
                    focusNode: latFocus,
                    child: TextField(
                      controller: latController,
                      focusNode: latFocus,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(hintText: "eg. 17.3850", border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // LONGITUDE
                  buildField(
                    label: "Parking Longitude",
                    focusNode: lngFocus,
                    child: TextField(
                      controller: lngController,
                      focusNode: lngFocus,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(hintText: "eg. 78.4867", border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // NOTES
                  buildField(
                    label: "Parking Notes",
                    focusNode: notesFocus,
                    child: TextField(
                      controller: notesController,
                      focusNode: notesFocus,
                      decoration: const InputDecoration(hintText: "eg. Parked near apartment gate", border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: vehicleProvider.isLoading || vehicleProvider.patchStatus == 'loading'
                          ? null
                          : () async {
                              // Validate fields (similar to AddVehicleScreen)
                              if (selectedMake == null) {
                                scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Vehicle make is required'), backgroundColor: Colors.redAccent));
                                return;
                              }
                              if (selectedModel == null) {
                                scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Vehicle model is required'), backgroundColor: Colors.redAccent));
                                return;
                              }
                              if (selectedSize == null) {
                                scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Vehicle size is required'), backgroundColor: Colors.redAccent));
                                return;
                              }
                              final lat = double.tryParse(latController.text.trim());
                              final lng = double.tryParse(lngController.text.trim());
                              if (lat == null) {
                                scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Invalid latitude'), backgroundColor: Colors.redAccent));
                                return;
                              }
                              if (lng == null) {
                                scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Invalid longitude'), backgroundColor: Colors.redAccent));
                                return;
                              }

                              final request = UpdateVehicleRequest(
                                brand: selectedMake,
                                model: selectedModel,
                                parkingLocationLat: lat,
                                parkingLocationLng: lng,
                                parkingNotes: notesController.text.trim(),
                                vehicleImage: _imageRemoved ? "" : null,
                              );

                              final success = await vehicleProvider.patchVehicle(
                                widget.vehicleId,
                                request,
                                imageFile: _newVehicleImageFile,
                              );
                              if (success) {
                                // Refresh user profile counts if needed
                                authProvider.fetchUserProfile();
                                navigator.pop(true);
                              } else {
                                scaffoldMessenger.showSnackBar(SnackBar(content: Text(vehicleProvider.error ?? 'Patch failed'), backgroundColor: Colors.redAccent));
                              }
                            },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF6C431), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                      child: vehicleProvider.patchStatus == 'loading'
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.5),
                            )
                          : const Text('Update Vehicle', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildField({required String label, required Widget child, required FocusNode? focusNode}) {
    return BorderFocusField(
      label: label,
      focusNode: focusNode,
      child: child,
    );
  }
}

class BorderFocusField extends StatefulWidget {
  final String label;
  final Widget child;
  final FocusNode? focusNode;

  const BorderFocusField({
    super.key,
    required this.label,
    required this.child,
    required this.focusNode,
  });

  @override
  State<BorderFocusField> createState() => _BorderFocusFieldState();
}

class _BorderFocusFieldState extends State<BorderFocusField> {
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode?.addListener(_onFocusChange);
    _hasFocus = widget.focusNode?.hasFocus ?? false;
  }

  @override
  void didUpdateWidget(covariant BorderFocusField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode?.removeListener(_onFocusChange);
      widget.focusNode?.addListener(_onFocusChange);
      _hasFocus = widget.focusNode?.hasFocus ?? false;
    }
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    final newFocus = widget.focusNode?.hasFocus ?? false;
    if (_hasFocus != newFocus) {
      setState(() {
        _hasFocus = newFocus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _hasFocus ? const Color(0xFFF6C431) : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          widget.child,
        ],
      ),
    );
  }
}
