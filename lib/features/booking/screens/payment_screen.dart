import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:autozy/features/booking/widgets/pay_button.dart';
import '../../../core/network/api_config.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/utils/app_logger.dart';
import '../../../data/models/dto/create_order_response.dart';
import '../../../providers/payment_provider.dart';

class PaymentScreen extends StatefulWidget {
  /// Subscription this payment settles. Required for the create-order call.
  final String subscriptionId;

  /// Amount to charge, in rupees.
  final num amount;

  const PaymentScreen({
    super.key,
    required this.subscriptionId,
    required this.amount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final Razorpay _razorpay;
  CreateOrderResponse? _order;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _showSnackBar(String message) {
    NavigationService.scaffoldMessengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _startPayment() async {
    final paymentProvider = context.read<PaymentProvider>();

    // Prefer the server-authoritative create-subscription-order endpoint; falls
    // back to create-order with the GST-inclusive amount if it isn't deployed.
    final order = await paymentProvider.createOrderForSubscription(
      subscriptionId: widget.subscriptionId,
      amount: widget.amount,
    );

    if (order == null) {
      _showSnackBar(paymentProvider.error ?? 'Failed to start payment');
      return;
    }

    _order = order;

    // Razorpay expects the amount in paise. Prefer the gateway-provided amount
    // (authoritative); fall back to converting the rupee amount we displayed.
    final amountInPaise =
        order.amount > 0 ? order.amount : (widget.amount * 100).round();

    final options = {
      'key': order.key ?? ApiConfig.razorpayKeyId,
      'order_id': order.razorpayOrderId,
      'amount': amountInPaise,
      'currency': order.currency,
      'name': 'Autozy',
      'description': 'Subscription Payment',
      'timeout': 300,
      'theme': {'color': '#F4C430'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      AppLogger.error('Failed to open Razorpay checkout', tag: 'Payments', error: e);
      _showSnackBar('Unable to open payment screen');
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final order = _order;
    if (order == null) {
      _showSnackBar('Payment session expired. Please try again.');
      return;
    }

    final paymentId = response.paymentId;
    final signature = response.signature;

    if (paymentId == null || signature == null) {
      _showSnackBar('Payment could not be confirmed. Please contact support.');
      return;
    }

    final paymentProvider = context.read<PaymentProvider>();
    final verified = await paymentProvider.verifyPayment(
      orderId: order.razorpayOrderId,
      paymentId: paymentId,
      signature: signature,
    );

    if (!mounted) return;

    if (verified) {
      context.goNamed('orderSuccess');
    } else {
      _showSnackBar(paymentProvider.error ?? 'Payment verification failed');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    AppLogger.warning(
      'Razorpay payment failed: code=${response.code}, message=${response.message}',
      tag: 'Payments',
    );
    _showSnackBar(response.message ?? 'Payment failed or was cancelled');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _showSnackBar('Continuing in ${response.walletName ?? 'wallet'}...');
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = context.watch<PaymentProvider>().isBusy;

    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      appBar: AppBar(
        title: const Text(
          "Payment",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Payment Methods",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Tap Pay to continue. You can choose UPI, cards, net banking "
                    "or wallets on the secure Razorpay screen — your installed UPI "
                    "apps will appear there automatically.",
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const _SupportedMethods(),
              const Spacer(),
              PayButton(
                price: widget.amount.toString(),
                onPressed: isBusy ? () {} : _startPayment,
              ),
            ],
          ),
          if (isBusy)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

/// Indicative (non-interactive) list of the payment categories Razorpay
/// supports. The actual method — and the installed UPI apps — are presented
/// dynamically by the Razorpay checkout sheet, not chosen here.
class _SupportedMethods extends StatelessWidget {
  const _SupportedMethods();

  static const _methods = <(IconData, String)>[
    (Icons.account_balance_wallet_outlined, 'UPI'),
    (Icons.credit_card, 'Cards'),
    (Icons.account_balance_outlined, 'Net Banking'),
    (Icons.wallet_outlined, 'Wallets'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final (icon, label) in _methods)
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xffFFF8E6),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: const Color(0xffF4C430)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
