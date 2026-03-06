import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/custom_card.dart';

class BookSlotScreen extends StatefulWidget {
  const BookSlotScreen({Key? key}) : super(key: key);

  @override
  State<BookSlotScreen> createState() => _BookSlotScreenState();
}

class _BookSlotScreenState extends State<BookSlotScreen> {
  DateTime? _selectedDate;
  String? _selectedTime;
  String? _selectedVehicle;

  final List<String> vehicles = [
    'Honda Civic - ABC-1234',
    'Toyota Camry - XYZ-5678',
  ];
  final List<String> timeSlots = [
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '2:00 PM',
    '3:00 PM',
    '4:00 PM',
    '5:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(AppStrings.bookSlot, style: AppTextStyles.headline2),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Vehicle', style: AppTextStyles.headline3),
              const SizedBox(height: 12),
              ...vehicles.map(
                (vehicle) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: CustomCard(
                    onTap: () {
                      setState(() {
                        _selectedVehicle = vehicle;
                      });
                    },
                    color: _selectedVehicle == vehicle
                        ? AppColors.primary.withOpacity(0.1)
                        : null,
                    child: Row(
                      children: [
                        Icon(
                          Icons.directions_car,
                          color: _selectedVehicle == vehicle
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            vehicle,
                            style: AppTextStyles.bodyText1.copyWith(
                              color: _selectedVehicle == vehicle
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (_selectedVehicle == vehicle)
                          Icon(Icons.check_circle, color: AppColors.primary),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Select Date', style: AppTextStyles.headline3),
              const SizedBox(height: 12),
              CustomCard(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (date != null) {
                    setState(() {
                      _selectedDate = date;
                    });
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: _selectedDate != null
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _selectedDate != null
                            ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                            : 'Select date',
                        style: AppTextStyles.bodyText1.copyWith(
                          color: _selectedDate != null
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Select Time', style: AppTextStyles.headline3),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: timeSlots.length,
                  itemBuilder: (context, index) {
                    final time = timeSlots[index];
                    final isSelected = _selectedTime == time;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTime = time;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.surface,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.divider,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            time,
                            style: AppTextStyles.bodyText2.copyWith(
                              color: isSelected
                                  ? AppColors.onPrimary
                                  : AppColors.textPrimary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Continue to Checkout',
                onPressed:
                    _selectedVehicle != null &&
                        _selectedDate != null &&
                        _selectedTime != null
                    ? () {
                        Navigator.pushNamed(context, '/checkout');
                      }
                    : () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
