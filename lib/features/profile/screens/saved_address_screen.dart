import 'package:flutter/material.dart';
import 'package:autozy/features/profile/widgets/address_card.dart';

class SavedAddressScreen extends StatefulWidget {
  const SavedAddressScreen({super.key});

  @override
  State<SavedAddressScreen> createState() => _SavedAddressScreenState();
}

class _SavedAddressScreenState extends State<SavedAddressScreen> {
  List<Map<String, String>> addresses = [
    {"title": "Home", "address": "Hyderabad"},
    {"title": "Work", "address": "Hitech City"},
  ];

  int defaultIndex = 0;

  Widget buildField(
    String hint,
    TextEditingController controller, {
    TextInputType? type,
    int? maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: type,
        maxLength: maxLength,
        decoration: InputDecoration(
          hintText: hint,
          counterText: "",
          filled: true,
          fillColor: Colors.grey.shade100,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFFC107), width: 1.5),
          ),
        ),
      ),
    );
  }

  void showAddAddressSheet({int? editIndex}) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final cityController = TextEditingController();
    final pincodeController = TextEditingController();

    if (editIndex != null) {
      final data = addresses[editIndex];
      nameController.text = data["title"]!;
      final parts = data["address"]!.split(", ");
      addressController.text = parts[0];
      cityController.text = parts.length > 1 ? parts[1] : "";
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
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
                  const SizedBox(width: 8),
                  Text(
                    editIndex != null ? "Edit Address" : "Add Address",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// MAP IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/map.png',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 16),

              /// FIELDS
              buildField("Home / Work", nameController),
              buildField("Full Address", addressController),
              buildField("City", cityController),
              buildField(
                "Pincode",
                pincodeController,
                type: TextInputType.number,
                maxLength: 6,
              ),

              const SizedBox(height: 10),

              /// BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFCB2F),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (nameController.text.isEmpty ||
                        addressController.text.isEmpty)
                      return;

                    setState(() {
                      final newData = {
                        "title": nameController.text,
                        "address":
                            "${addressController.text}, ${cityController.text}",
                      };

                      if (editIndex != null) {
                        addresses[editIndex] = newData;
                      } else {
                        addresses.add(newData);
                      }
                    });

                    Navigator.pop(context);
                  },
                  child: Text(
                    editIndex != null ? "Update Address" : "Add Address",
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildOption(
    IconData icon,
    String text,
    VoidCallback onTap,
    Color? color,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E3),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Saved Addresses",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Column(
        children: [
          /// ADDRESS LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final item = addresses[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AddressCard(
                    title: item["title"]!,
                    address: item["address"]!,

                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (_) {
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                buildOption(Icons.edit, "Edit Address", () {
                                  Navigator.pop(context);
                                  showAddAddressSheet(editIndex: index);
                                }, null),

                                buildOption(Icons.delete, "Delete Address", () {
                                  setState(() => addresses.removeAt(index));
                                  Navigator.pop(context);
                                }, Colors.red),

                                buildOption(Icons.star, "Set as Default", () {
                                  setState(() => defaultIndex = index);
                                  Navigator.pop(context);
                                }, null),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),

          /// ADD BUTTON
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFCB2F),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => showAddAddressSheet(),
                child: const Text(
                  "Add New Address",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
