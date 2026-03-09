import 'package:flutter/material.dart';

class VehicleScreen extends StatelessWidget {
  const VehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("My Vehicles", style: TextStyle(color: Colors.black)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            /// VEHICLE CARD
            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 10,
                  ),
                ],
              ),

              child: Row(
                children: [
                  /// ICON
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6C431),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.directions_car),
                  ),

                  const SizedBox(width: 16),

                  /// VEHICLE DETAILS
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hyundai Creta",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "TS 01 AB 1234 • Sedan",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  /// CURRENT TAG
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green),
                    ),

                    child: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                        SizedBox(width: 4),
                        Text("Current", style: TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  const Icon(Icons.delete_outline, color: Colors.red),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// ADD VEHICLE BUTTON
            Container(
              width: double.infinity,
              height: 60,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xffC68A00), width: 2),
              ),

              child: const Center(
                child: Text(
                  "+  Add Vehicle",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xffC68A00),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
