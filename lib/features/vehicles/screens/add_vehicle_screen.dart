import 'package:flutter/material.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final numberController = TextEditingController();
  final makeController = TextEditingController();
  final modelController = TextEditingController();
  final sizeController = TextEditingController();

  @override
  void dispose() {
    numberController.dispose();
    makeController.dispose();
    modelController.dispose();
    sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  "Add Vehicle",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 20),

            TextField(
              controller: numberController,
              decoration: InputDecoration(
                hintText: "eg. TS 01 AB 1234",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: "Vehicle Number",
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: makeController,
              decoration: InputDecoration(
                labelText: "Select Make",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: const Icon(Icons.keyboard_arrow_down),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: modelController,
              decoration: InputDecoration(
                labelText: "Select Model",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: const Icon(Icons.keyboard_arrow_down),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: sizeController,
              decoration: InputDecoration(
                labelText: "Select Size",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: const Icon(Icons.keyboard_arrow_down),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final vehicle = {
                    "number": numberController.text,
                    "make": makeController.text,
                    "model": modelController.text,
                    "size": sizeController.text,
                  };

                  Navigator.pop(context, vehicle);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF6C431),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Add Vehicle",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
