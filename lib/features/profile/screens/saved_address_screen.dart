import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:autozy/features/profile/widgets/address_card.dart';
import '../../../providers/user_address_provider.dart';
import '../../../data/models/user_address_model.dart';

class SavedAddressScreen extends StatefulWidget {
  const SavedAddressScreen({super.key});

  @override
  State<SavedAddressScreen> createState() => _SavedAddressScreenState();
}

class _SavedAddressScreenState extends State<SavedAddressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserAddressProvider>().fetchAddresses();
    });
  }

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

  void showAddAddressSheet({UserAddress? existing}) {
    final flatController = TextEditingController(text: existing?.flatNo ?? '');
    final buildingController = TextEditingController(text: existing?.building ?? '');
    final localityController = TextEditingController(text: existing?.locality ?? '');
    final landmarkController = TextEditingController(text: existing?.landmark ?? '');
    final cityController = TextEditingController(text: existing?.city ?? '');
    final stateController = TextEditingController(text: existing?.state ?? '');
    final pincodeController = TextEditingController(text: existing?.pincode ?? '');
    bool isDefault = existing?.isDefault ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// HEADER
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(sheetContext),
                          child: const Icon(Icons.close),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          existing != null ? "Edit Address" : "Add Address",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    /// FIELDS
                    buildField("Flat / House No", flatController),
                    buildField("Building / Apartment", buildingController),
                    buildField("Locality / Area", localityController),
                    buildField("Landmark (optional)", landmarkController),
                    buildField("City", cityController),
                    buildField("State", stateController),
                    buildField(
                      "Pincode",
                      pincodeController,
                      type: TextInputType.number,
                      maxLength: 6,
                    ),

                    /// DEFAULT TOGGLE
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeColor: const Color(0xFFFFC107),
                      title: const Text("Set as default address"),
                      value: isDefault,
                      onChanged: (v) => setSheetState(() => isDefault = v),
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
                        onPressed: () async {
                          // Minimal validation for required backend fields.
                          if (flatController.text.trim().isEmpty ||
                              buildingController.text.trim().isEmpty ||
                              localityController.text.trim().isEmpty ||
                              cityController.text.trim().isEmpty ||
                              stateController.text.trim().isEmpty ||
                              pincodeController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please fill all required fields"),
                              ),
                            );
                            return;
                          }

                          final provider = context.read<UserAddressProvider>();
                          final address = UserAddress(
                            id: existing?.id ?? '',
                            flatNo: flatController.text.trim(),
                            building: buildingController.text.trim(),
                            locality: localityController.text.trim(),
                            landmark: landmarkController.text.trim().isEmpty
                                ? null
                                : landmarkController.text.trim(),
                            city: cityController.text.trim(),
                            state: stateController.text.trim(),
                            pincode: pincodeController.text.trim(),
                            lat: existing?.lat,
                            lng: existing?.lng,
                            isDefault: isDefault,
                          );

                          final ok = existing != null
                              ? await provider.editAddress(existing.id, address)
                              : await provider.addAddress(address);

                          if (!sheetContext.mounted) return;
                          Navigator.pop(sheetContext);
                          if (!mounted) return;
                          if (!ok) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(provider.error ?? "Failed to save address"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: Text(
                          existing != null ? "Update Address" : "Add Address",
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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
    final provider = context.watch<UserAddressProvider>();
    final addresses = provider.addresses;

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
          Expanded(
            child: _buildBody(provider, addresses),
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

  Widget _buildBody(UserAddressProvider provider, List<UserAddress> addresses) {
    if (provider.isLoading && addresses.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFFFFC107)));
    }

    if (provider.error != null && addresses.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
              const SizedBox(height: 12),
              Text(
                provider.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => provider.fetchAddresses(),
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    if (addresses.isEmpty) {
      return const Center(
        child: Text(
          "No saved addresses yet.\nTap 'Add New Address' to create one.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.fetchAddresses(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: addresses.length,
        itemBuilder: (context, index) {
          final item = addresses[index];
          final title = item.building.isNotEmpty ? item.building : item.locality;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AddressCard(
              title: item.isDefault ? "$title  •  Default" : title,
              address: item.formatted,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (sheetContext) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildOption(Icons.edit, "Edit Address", () {
                            Navigator.pop(sheetContext);
                            showAddAddressSheet(existing: item);
                          }, null),
                          buildOption(Icons.delete, "Delete Address", () async {
                            Navigator.pop(sheetContext);
                            await provider.removeAddress(item.id);
                          }, Colors.red),
                          if (!item.isDefault)
                            buildOption(Icons.star, "Set as Default", () async {
                              Navigator.pop(sheetContext);
                              await provider.setDefault(item);
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
    );
  }
}
