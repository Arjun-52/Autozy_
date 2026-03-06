import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/custom_textfield.dart';
import '../../core/utils/validators.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({Key? key}) : super(key: key);

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();

  String _selectedType = 'Sedan';

  final List<String> _vehicleTypes = [
    'Sedan',
    'SUV',
    'Truck',
    'Motorcycle',
    'Van',
    'Coupe',
    'Convertible',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(AppStrings.addVehicle, style: AppTextStyles.headline2),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      CustomTextfield(
                        labelText: AppStrings.vehicleName,
                        hintText: 'Enter vehicle name',
                        controller: _nameController,
                        prefixIcon: Icons.directions_car,
                        validator: Validators.validateName,
                      ),
                      const SizedBox(height: 16),
                      CustomTextfield(
                        labelText: AppStrings.vehicleNumber,
                        hintText: 'Enter vehicle number',
                        controller: _numberController,
                        prefixIcon: Icons.confirmation_number,
                        validator: (value) => Validators.validateRequired(
                          value,
                          'Vehicle number',
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedType,
                        decoration: InputDecoration(
                          labelText: AppStrings.vehicleType,
                          prefixIcon: const Icon(Icons.category),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: _vehicleTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextfield(
                        labelText: 'Brand',
                        hintText: 'Enter vehicle brand',
                        controller: _brandController,
                        prefixIcon: Icons.business,
                        validator: Validators.validateName,
                      ),
                      const SizedBox(height: 16),
                      CustomTextfield(
                        labelText: 'Model',
                        hintText: 'Enter vehicle model',
                        controller: _modelController,
                        prefixIcon: Icons.info,
                        validator: Validators.validateName,
                      ),
                      const SizedBox(height: 16),
                      CustomTextfield(
                        labelText: 'Year',
                        hintText: 'Enter vehicle year',
                        controller: _yearController,
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.calendar_today,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Year is required';
                          }
                          final year = int.tryParse(value);
                          if (year == null ||
                              year < 1900 ||
                              year > DateTime.now().year + 1) {
                            return 'Please enter a valid year';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  text: 'Add Vehicle',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Add vehicle logic
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Vehicle added successfully'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
