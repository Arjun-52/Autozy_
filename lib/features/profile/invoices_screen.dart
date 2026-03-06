import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/widgets/custom_card.dart';

class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Invoices',
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
                'Billing History',
                style: AppTextStyles.headline3,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildInvoiceCard(
                      'INV-2024-001',
                      '15 March 2024',
                      '\$54.99',
                      'Paid',
                      AppColors.success,
                    ),
                    _buildInvoiceCard(
                      'INV-2024-002',
                      '10 February 2024',
                      '\$79.99',
                      'Paid',
                      AppColors.success,
                    ),
                    _buildInvoiceCard(
                      'INV-2024-003',
                      '5 January 2024',
                      '\$29.99',
                      'Paid',
                      AppColors.success,
                    ),
                    _buildInvoiceCard(
                      'INV-2023-004',
                      '20 December 2023',
                      '\$49.99',
                      'Paid',
                      AppColors.success,
                    ),
                    _buildInvoiceCard(
                      'INV-2023-005',
                      '15 November 2023',
                      '\$39.99',
                      'Paid',
                      AppColors.success,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceCard(
    String invoiceNumber,
    String date,
    String amount,
    String status,
    Color statusColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CustomCard(
        onTap: () {
          // Navigate to invoice details
        },
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.receipt,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    invoiceNumber,
                    style: AppTextStyles.headline3,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: AppTextStyles.bodyText2,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: AppTextStyles.headline3.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: AppTextStyles.caption.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
