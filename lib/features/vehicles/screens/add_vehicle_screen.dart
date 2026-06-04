import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

    return Container(
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
                  items: ["SMALL", "MEDIUM", "LARGE"]
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

            /// PARKING LATITUDE
            buildField(
              label: "Parking Latitude",
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

            const SizedBox(height: 12),

            /// PARKING LONGITUDE
            buildField(
              label: "Parking Longitude",
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

                        final lat = double.tryParse(latController.text.trim());
                        final lng = double.tryParse(lngController.text.trim());

                        if (lat == null) {
                          setState(() {
                            localError = "Please enter a valid latitude coordinate";
                          });
                          AppLogger.error('Validation failures: Invalid latitude value', tag: 'Vehicles');
                          try {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please enter a valid latitude coordinate"),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          } catch (_) {}
                          return;
                        }

                        if (lng == null) {
                          setState(() {
                            localError = "Please enter a valid longitude coordinate";
                          });
                          AppLogger.error('Validation failures: Invalid longitude value', tag: 'Vehicles');
                          try {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please enter a valid longitude coordinate"),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          } catch (_) {}
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

                        // Capture values before async gap to avoid linter warnings
                        final authProvider = context.read<AuthProvider>();
                        final vehicleProv = context.read<VehicleProvider>();
                        final navigator = Navigator.of(context);
                        final scaffoldMessenger = ScaffoldMessenger.of(context);

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
