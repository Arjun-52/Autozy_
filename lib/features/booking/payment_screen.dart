import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/custom_card.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'card';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          AppStrings.payment,
          style: AppTextStyles.headline2,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Method',
                style: AppTextStyles.headline3,
              ),
              const SizedBox(height: 16),
              CustomCard(
                child: Column(
                  children: [
                    _buildPaymentOption(
                      'Credit/Debit Card',
                      Icons.credit_card,
                      'card',
                    ),
                    const Divider(),
                    _buildPaymentOption(
                      'PayPal',
                      Icons.account_balance_wallet,
                      'paypal',
                    ),
                    const Divider(),
                    _buildPaymentOption(
                      'Cash on Arrival',
                      Icons.money,
                      'cash',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (_selectedPaymentMethod == 'card') ...[
                Text(
                  'Card Details',
                  style: AppTextStyles.headline3,
                ),
                const SizedBox(height: 16),
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Card Number',
                          hintText: '1234 5678 9012 3456',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Expiry Date',
                                hintText: 'MM/YY',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'CVV',
                                hintText: '123',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              const Spacer(),
              CustomCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount',
                      style: AppTextStyles.headline3,
                    ),
                    Text(
                      '\$54.99',
                      style: AppTextStyles.headline3.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                text: 'Complete Payment',
                onPressed: () {
                  Navigator.pushNamed(context, '/order-success');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String title, IconData icon, String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyText1,
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
