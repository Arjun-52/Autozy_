import 'package:flutter/material.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final numberController = TextEditingController();

  final numberFocus = FocusNode();

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
    numberFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                hintText: "eg. TS 01 AB 1234",
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
                items: ["SUV", "Sedan", "Hatchback"]
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

          const SizedBox(height: 20),

          /// BUTTON
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                if (numberController.text.isEmpty ||
                    selectedMake == null ||
                    selectedModel == null ||
                    selectedSize == null)
                  return;

                Navigator.pop(context, {
                  "number": numberController.text,
                  "make": selectedMake!,
                  "model": selectedModel!,
                  "size": selectedSize!,
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF6C431),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
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
