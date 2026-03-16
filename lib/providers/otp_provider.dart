import 'dart:async';
import 'package:flutter/material.dart';

class OtpProvider extends ChangeNotifier {
  /// TIMER VARIABLES
  int secondsRemaining = 30;
  bool canResend = false;
  Timer? _timer;

  /// OTP STORAGE
  List<String> otpDigits = ["", "", "", ""];

  /// Start OTP timer
  void startTimer() {
    _timer?.cancel();

    secondsRemaining = 30;
    canResend = false;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        secondsRemaining--;
      } else {
        canResend = true;
        timer.cancel();
      }
      notifyListeners();
    });
  }

  /// Update OTP digit
  void updateOtp(int index, String value) {
    otpDigits[index] = value;
    notifyListeners();
  }

  /// Get full OTP
  String get otp {
    return otpDigits.join();
  }

  /// Clear OTP if needed
  void clearOtp() {
    otpDigits = ["", "", "", ""];
    notifyListeners();
  }

  /// Dispose timer
  void disposeTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    disposeTimer();
    super.dispose();
  }
}
