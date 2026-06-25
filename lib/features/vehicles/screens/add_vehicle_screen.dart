import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
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
  // Vehicle Detail Controllers
  final numberController = TextEditingController();
  String? selectedMake;
  String? selectedModel;
  String? selectedSize;

  // Parking Detail Controllers
  final latController = TextEditingController(text: "17.3850");
  final lngController = TextEditingController(text: "78.4867");
  final notesController = TextEditingController();

  // Address Detail Controllers
  final flatController = TextEditingController();
  final buildingController = TextEditingController();
  final localityController = TextEditingController();
  final landmarkController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();

  // Focus Nodes
  final numberFocus = FocusNode();
  final latFocus = FocusNode();
  final lngFocus = FocusNode();
  final notesFocus = FocusNode();
  final flatFocus = FocusNode();
  final buildingFocus = FocusNode();
  final localityFocus = FocusNode();
  final landmarkFocus = FocusNode();
  final cityFocus = FocusNode();
  final stateFocus = FocusNode();
  final pincodeFocus = FocusNode();

  String? localError;
  bool _isLocating = false;

  final Map<String, List<String>> carModels = {
    "Hyundai": ["Creta", "i20", "Verna"],
    "Honda": ["City", "Civic"],
    "Toyota": ["Innova", "Fortuner"],
  };

  @override
  void initState() {
    super.initState();
    final provider = context.read<VehicleProvider>();
    
    numberController.text = provider.regNumber;
    latController.text = provider.latitude;
    lngController.text = provider.longitude;
    notesController.text = provider.parkingNotes;
    flatController.text = provider.flat;
    buildingController.text = provider.building;
    localityController.text = provider.locality;
    landmarkController.text = provider.landmark;
    cityController.text = provider.city;
    stateController.text = provider.stateName;
    pincodeController.text = provider.pincode;
    
    selectedMake = provider.brand;
    selectedModel = provider.model;
    selectedSize = provider.size;

    numberController.addListener(() => provider.setRegNumber(numberController.text));
    latController.addListener(() => provider.setLatitude(latController.text));
    lngController.addListener(() => provider.setLongitude(lngController.text));
    notesController.addListener(() => provider.setParkingNotes(notesController.text));
    flatController.addListener(() => provider.setFlat(flatController.text));
    buildingController.addListener(() => provider.setBuilding(buildingController.text));
    localityController.addListener(() => provider.setLocality(localityController.text));
    landmarkController.addListener(() => provider.setLandmark(landmarkController.text));
    cityController.addListener(() => provider.setCity(cityController.text));
    stateController.addListener(() => provider.setStateName(stateController.text));
    pincodeController.addListener(() => provider.setPincode(pincodeController.text));
  }

  @override
  void dispose() {
    numberController.dispose();
    latController.dispose();
    lngController.dispose();
    notesController.dispose();
    flatController.dispose();
    buildingController.dispose();
    localityController.dispose();
    landmarkController.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();

    numberFocus.dispose();
    latFocus.dispose();
    lngFocus.dispose();
    notesFocus.dispose();
    flatFocus.dispose();
    buildingFocus.dispose();
    localityFocus.dispose();
    landmarkFocus.dispose();
    cityFocus.dispose();
    stateFocus.dispose();
    pincodeFocus.dispose();
    super.dispose();
  }

  // Location Retrieval Logic
  Future<void> _checkPermissionAndGetLocation() async {
    setState(() {
      _isLocating = true;
      localError = null;
    });

    try {
      final permission = await Permission.location.status;
      if (permission.isDenied) {
        final requestResult = await Permission.location.request();
        if (requestResult.isDenied) {
          setState(() {
            localError = "Location access required to fetch parking coordinates.";
            _isLocating = false;
          });
          return;
        }
      }

      if (await Permission.location.isPermanentlyDenied) {
        setState(() {
          localError = "Location access is permanently denied. Please enable it in settings.";
          _isLocating = false;
        });
        return;
      }

      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        setState(() {
          localError = "Location services are disabled. Please enable GPS.";
          _isLocating = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 8),
      );

      if (mounted) {
        latController.text = position.latitude.toStringAsFixed(6);
        lngController.text = position.longitude.toStringAsFixed(6);
        AppLogger.info('Location retrieved successfully: ${position.latitude}, ${position.longitude}', tag: 'Vehicles');
      }
    } catch (e) {
      setState(() {
        localError = "Unable to determine current location";
        _isLocating = false;
      });
      AppLogger.error("Location fetching error", error: e);
    } finally {
      if (mounted) {
        setState(() {
          _isLocating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = context.watch<VehicleProvider>();

    return PopScope(
      canPop: !vehicleProvider.isRegistrationFormDirty(),
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final discard = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Discard Changes?"),
              content: const Text(
                  "Your vehicle details have not been submitted yet. Do you want to discard the entered information?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Continue Editing"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Discard Changes",
                      style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );

        if (discard == true && context.mounted) {
          context.read<VehicleProvider>().resetRegistrationForm();
          Navigator.of(context).pop(result);
        }
      },
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Add Vehicle",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<VehicleProvider>().resetRegistrationForm();
                        numberController.clear();
                        latController.text = "17.3850";
                        lngController.text = "78.4867";
                        notesController.clear();
                        flatController.clear();
                        buildingController.clear();
                        localityController.clear();
                        landmarkController.clear();
                        cityController.clear();
                        stateController.clear();
                        pincodeController.clear();
                        setState(() {
                          selectedMake = null;
                          selectedModel = null;
                          selectedSize = null;
                          localError = null;
                        });
                      },
                      child: const Text(
                        "Reset",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 20),

              /// SECTION 1: VEHICLE DETAILS
              const Text(
                "Vehicle Details",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blueGrey),
              ),
              const SizedBox(height: 10),

              buildField(
                label: "Vehicle Number",
                focusNode: numberFocus,
                child: TextField(
                  controller: numberController,
                  focusNode: numberFocus,
                  textCapitalization: TextCapitalization.characters,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: "eg. TS09AB1234",
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 12),

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
                      final provider = context.read<VehicleProvider>();
                      provider.setBrand(value);
                      provider.setModel(null);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 12),

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
                      context.read<VehicleProvider>().setModel(value);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 12),

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
                      context.read<VehicleProvider>().setSize(value);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// SECTION 2: PARKING DETAILS
              const Text(
                "Parking Details",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blueGrey),
              ),
              const SizedBox(height: 10),

              /// MAP BANNER
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/map.png',
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: FloatingActionButton.small(
                      backgroundColor: const Color(0xFFF6C431),
                      onPressed: _isLocating ? null : _checkPermissionAndGetLocation,
                      child: _isLocating
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                            )
                          : const Icon(Icons.my_location, color: Colors.black),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: buildField(
                      label: "Latitude",
                      focusNode: latFocus,
                      child: TextField(
                        controller: latController,
                        focusNode: latFocus,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          hintText: "eg. 17.3850",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: buildField(
                      label: "Longitude",
                      focusNode: lngFocus,
                      child: TextField(
                        controller: lngController,
                        focusNode: lngFocus,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          hintText: "eg. 78.4867",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              buildField(
                label: "Parking Notes",
                focusNode: notesFocus,
                child: TextField(
                  controller: notesController,
                  focusNode: notesFocus,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: "eg. Parked near apartment gate",
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// SECTION 3: ADDRESS DETAILS
              const Text(
                "Address Details",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blueGrey),
              ),
              const SizedBox(height: 10),

              buildField(
                label: "Flat / House Number",
                focusNode: flatFocus,
                child: TextField(
                  controller: flatController,
                  focusNode: flatFocus,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: "eg. Flat 402",
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              buildField(
                label: "Building / Apartment Name",
                focusNode: buildingFocus,
                child: TextField(
                  controller: buildingController,
                  focusNode: buildingFocus,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: "eg. Oak Heights",
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              buildField(
                label: "Locality / Area",
                focusNode: localityFocus,
                child: TextField(
                  controller: localityController,
                  focusNode: localityFocus,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: "eg. Madhapur",
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              buildField(
                label: "Landmark",
                focusNode: landmarkFocus,
                child: TextField(
                  controller: landmarkController,
                  focusNode: landmarkFocus,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: "eg. Near Metro Pillar C10",
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: buildField(
                      label: "City",
                      focusNode: cityFocus,
                      child: TextField(
                        controller: cityController,
                        focusNode: cityFocus,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          hintText: "eg. Hyderabad",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: buildField(
                      label: "State",
                      focusNode: stateFocus,
                      child: TextField(
                        controller: stateController,
                        focusNode: stateFocus,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          hintText: "eg. Telangana",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              buildField(
                label: "Pincode",
                focusNode: pincodeFocus,
                child: TextField(
                  controller: pincodeController,
                  focusNode: pincodeFocus,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 6,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: "eg. 500081",
                    border: InputBorder.none,
                    counterText: "",
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// SECTION 4: SUMMARY & OVERVIEW
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Summary Overview",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Address: ${flatController.text.isNotEmpty ? '${flatController.text}, ' : ''}${buildingController.text.isNotEmpty ? '${buildingController.text}, ' : ''}${localityController.text.isNotEmpty ? '${localityController.text}, ' : ''}${cityController.text.isNotEmpty ? '${cityController.text}, ' : ''}${pincodeController.text}",
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                    if (notesController.text.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        "Parking Notes: ${notesController.text}",
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                      ),
                    ],
                  ],
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

              /// SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: vehicleProvider.isLoading
                      ? null
                      : () async {
                          final vehicleProv = context.read<VehicleProvider>();
                          final rawNumber = numberController.text.trim();
                          if (rawNumber.isEmpty) {
                            setState(() => localError = "Vehicle number is required");
                            return;
                          }

                          final formattedNumber = rawNumber.replaceAll(' ', '').toUpperCase();

                          final isDuplicate = vehicleProv.vehicles.any(
                            (v) => v.vehicleNumber.replaceAll(' ', '').toUpperCase() == formattedNumber
                          );
                          if (isDuplicate) {
                            setState(() => localError = "Vehicle with this number is already registered");
                            return;
                          }

                          if (selectedMake == null) {
                            setState(() => localError = "Vehicle make is required");
                            return;
                          }
                          if (selectedModel == null) {
                            setState(() => localError = "Vehicle model is required");
                            return;
                          }
                          if (selectedSize == null) {
                            setState(() => localError = "Vehicle size category is required");
                            return;
                          }

                          final lat = double.tryParse(latController.text.trim());
                          final lng = double.tryParse(lngController.text.trim());

                          if (lat == null || lng == null) {
                            setState(() => localError = "Valid latitude and longitude coordinates are required");
                            return;
                          }

                          if (flatController.text.trim().isEmpty) {
                            setState(() => localError = "Flat / House Number is required");
                            return;
                          }
                          if (buildingController.text.trim().isEmpty) {
                            setState(() => localError = "Building / Apartment Name is required");
                            return;
                          }
                          if (localityController.text.trim().isEmpty) {
                            setState(() => localError = "Locality / Area is required");
                            return;
                          }
                          if (cityController.text.trim().isEmpty) {
                            setState(() => localError = "City is required");
                            return;
                          }
                          if (stateController.text.trim().isEmpty) {
                            setState(() => localError = "State is required");
                            return;
                          }
                          if (pincodeController.text.trim().length != 6) {
                            setState(() => localError = "A valid 6-digit pincode is required");
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
                            flatNo: flatController.text.trim(),
                            building: buildingController.text.trim(),
                            locality: localityController.text.trim(),
                            landmark: landmarkController.text.trim(),
                            city: cityController.text.trim(),
                            state: stateController.text.trim(),
                            pincode: pincodeController.text.trim(),
                          );

                          final authProvider = context.read<AuthProvider>();
                          final navigator = Navigator.of(context);
                          final scaffoldMessenger = ScaffoldMessenger.of(context);

                          final success = await vehicleProv.createVehicle(request: request);

                          if (success) {
                            setState(() => localError = null);
                            try {
                              scaffoldMessenger.showSnackBar(
                                const SnackBar(
                                  content: Text("Vehicle Added Successfully"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } catch (_) {}
                            authProvider.fetchUserProfile();
                            navigator.pop(true);
                          } else {
                            final errorMsg = vehicleProv.error ?? "Something went wrong";
                            setState(() => localError = errorMsg);
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
    ),
  );
}

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
