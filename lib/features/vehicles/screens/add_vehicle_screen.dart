import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'map_picker_screen.dart';
import '../../../core/utils/app_logger.dart';
import '../../../data/models/dto/add_vehicle_request.dart';
import '../../../providers/vehicle_provider.dart';
import '../../../providers/auth_provider.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final numberController = TextEditingController();
  final latController = TextEditingController(text: "17.3850");
  final lngController = TextEditingController(text: "78.4867");
  final notesController = TextEditingController();

  String? localError;
  bool _isDetectingLocation = false;
  String? _selectedAddress;

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

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    if (mounted) {
      setState(() {
        _isDetectingLocation = true;
      });
    }
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppLogger.warning('Location services are disabled.', tag: 'Vehicles');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          AppLogger.warning('Location permissions are denied.', tag: 'Vehicles');
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        AppLogger.warning('Location permissions are permanently denied.', tag: 'Vehicles');
        return;
      } 

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      String address = "Coordinates captured successfully";
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          List<String> parts = [];
          if (place.name != null && place.name!.isNotEmpty && place.name != place.street) {
            parts.add(place.name!);
          }
          if (place.street != null && place.street!.isNotEmpty) {
            parts.add(place.street!);
          }
          if (place.subLocality != null && place.subLocality!.isNotEmpty) {
            parts.add(place.subLocality!);
          }
          if (place.locality != null && place.locality!.isNotEmpty) {
            parts.add(place.locality!);
          }
          if (parts.isNotEmpty) {
            address = parts.join(', ');
          }
        }
      } catch (geocodeErr) {
        AppLogger.error('Geocoding error in auto-detect', error: geocodeErr);
      }

      if (mounted) {
        setState(() {
          latController.text = position.latitude.toString();
          lngController.text = position.longitude.toString();
          _selectedAddress = address;
        });
        AppLogger.info('Automatically captured GPS coordinates: ${position.latitude}, ${position.longitude}', tag: 'Vehicles');
      }
    } catch (e) {
      AppLogger.error('Failed to get location automatically', tag: 'Vehicles', error: e);
    } finally {
      if (mounted) {
        setState(() {
          _isDetectingLocation = false;
        });
      }
    }
  }

  @override
  void dispose() {
    numberController.dispose();
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

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            /// HEADER
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Add Vehicle",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// VEHICLE NUMBER
            buildField(
              label: "Vehicle Number",
              focusNode: numberFocus,
              child: TextField(
                controller: numberController,
                focusNode: numberFocus,
                decoration: const InputDecoration(
                  hintText: "eg. TS09AB1234",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// MAKE
            buildField(
              label: "Select Make",
              focusNode: null,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedMake,
                  hint: const Text("Select Make"),
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
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

            /// MODEL
            buildField(
              label: "Select Model",
              focusNode: null,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedModel,
                  hint: const Text("Select Model"),
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: (carModels[selectedMake] ?? [])
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedModel = value;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// SIZE
            buildField(
              label: "Select Size",
              focusNode: null,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedSize,
                  hint: const Text("Select Size"),
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: ["HATCHBACK", "SEDAN", "SUV", "PREMIUM"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSize = value;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// PARKING LOCATION SELECTOR CARD
            buildField(
              label: "Parking Location",
              focusNode: null,
              child: InkWell(
                onTap: () async {
                  final result = await Navigator.push<MapPickerResult>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapPickerScreen(
                        initialLat: double.tryParse(latController.text),
                        initialLng: double.tryParse(lngController.text),
                      ),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      latController.text = result.latitude.toString();
                      lngController.text = result.longitude.toString();
                      _selectedAddress = result.address;
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.map, color: Color(0xFFF6C431)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedAddress ?? (_isDetectingLocation ? "Detecting current location..." : "Tap to select parking location"),
                              style: TextStyle(
                                fontWeight: _selectedAddress != null ? FontWeight.w600 : FontWeight.normal,
                                color: _selectedAddress != null ? Colors.black : Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_isDetectingLocation)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFF6C431)),
                        )
                      else
                        const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// PARKING NOTES
            buildField(
              label: "Parking Notes",
              focusNode: notesFocus,
              child: TextField(
                controller: notesController,
                focusNode: notesFocus,
                decoration: const InputDecoration(
                  hintText: "eg. Parked near apartment gate",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (localError != null) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  localError!,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],

            /// BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: vehicleProvider.isLoading
                    ? null
                    : () async {
                        final rawNumber = numberController.text.trim();
                        if (rawNumber.isEmpty) {
                          setState(() {
                            localError = "Vehicle number is required";
                          });
                          AppLogger.error('Validation failures: Vehicle number is required', tag: 'Vehicles');
                          try {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Vehicle number is required"),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          } catch (_) {}
                          return;
                        }
                        
                        final formattedNumber = rawNumber.replaceAll(' ', '').toUpperCase();

                        if (selectedMake == null) {
                          setState(() {
                            localError = "Vehicle make is required";
                          });
                          AppLogger.error('Validation failures: Vehicle make is required', tag: 'Vehicles');
                          try {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Vehicle make is required"),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          } catch (_) {}
                          return;
                        }
                        if (selectedModel == null) {
                          setState(() {
                            localError = "Vehicle model is required";
                          });
                          AppLogger.error('Validation failures: Vehicle model is required', tag: 'Vehicles');
                          try {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Vehicle model is required"),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          } catch (_) {}
                          return;
                        }
                        if (selectedSize == null) {
                          setState(() {
                            localError = "Vehicle size is required";
                          });
                          AppLogger.error('Validation failures: Vehicle size is required', tag: 'Vehicles');
                          try {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Vehicle size is required"),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          } catch (_) {}
                          return;
                        }

                        if (_selectedAddress == null) {
                          setState(() {
                            localError = "Please select a parking location on the map";
                          });
                          AppLogger.error('Validation failures: Parking location not selected', tag: 'Vehicles');
                          try {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please select a parking location on the map"),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          } catch (_) {}
                          return;
                        }

                        final lat = double.tryParse(latController.text.trim()) ?? 17.3850;
                        final lng = double.tryParse(lngController.text.trim()) ?? 78.4867;

                        // Capture values before async gap to avoid linter warnings
                        final authProvider = context.read<AuthProvider>();
                        final vehicleProv = context.read<VehicleProvider>();
                        final navigator = Navigator.of(context);
                        final scaffoldMessenger = ScaffoldMessenger.of(context);

                        // Check for existing active vehicle at this location
                        final hasActive = await vehicleProv.hasActiveVehicleAtLocation(lat, lng);
                        if (hasActive) {
                          setState(() {
                            localError = "This address already has an active vehicle registered. Please remove or deactivate the existing vehicle before proceeding.";
                          });
                          scaffoldMessenger.showSnackBar(const SnackBar(
                            content: Text("This address already has an active vehicle registered. Please remove or deactivate the existing vehicle before proceeding."),
                            backgroundColor: Colors.redAccent,
                          ));
                          return;
                        }

                        final request = AddVehicleRequest(
                          vehicleNumber: formattedNumber,
                          brand: selectedMake!,
                          model: selectedModel!,
                          sizeCategory: selectedSize!,
                          parkingLocationLat: lat,
                          parkingLocationLng: lng,
                          parkingNotes: notesController.text.trim(),
                        );

                        

                        final success = await vehicleProv.createVehicle(request: request);

                        if (success) {
                          setState(() {
                            localError = null;
                          });
                          // Display success message using existing project pattern
                          try {
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(
                                content: Text("Vehicle Added Successfully"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (_) {}
                          
                          // Refresh User profile counts to keep state synchronized
                          authProvider.fetchUserProfile();

                          navigator.pop(true);
                        } else {
                          final errorMsg = vehicleProv.error ?? "Something went wrong";
                          setState(() {
                            localError = errorMsg;
                          });
                          try {
                            scaffoldMessenger.showSnackBar(
                              SnackBar(
                                content: Text(errorMsg),
                                backgroundColor: Colors.redAccent,
                                action: SnackBarAction(
                                  label: 'Retry',
                                  textColor: Colors.white,
                                  onPressed: () {
                                    // Retry action
                                  },
                                ),
                              ),
                            );
                          } catch (_) {}
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF6C431),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: vehicleProvider.isLoading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text(
                        "Add Vehicle",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  /// FIELD WITH FOCUS BORDER EFFECT
  Widget buildField({
    required String label,
    required Widget child,
    required FocusNode? focusNode,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        focusNode?.addListener(() => setState(() {}));

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: focusNode != null && focusNode.hasFocus
                  ? const Color(0xFFF6C431)
                  : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              child,
            ],
          ),
        );
      },
    );
  }
}
