import 'dart:async';
import 'package:flutter/material.dart';

class OtpProvider extends ChangeNotifier {
  int secondsRemaining = 30;
  bool canResend = false;
  Timer? _timer;

  void startTimer() {
    secondsRemaining = 30;
    canResend = false;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        secondsRemaining--;
        notifyListeners();
      } else {
        canResend = true;
        timer.cancel();
        notifyListeners();
      }
    });
  }

  void disposeTimer() {
    _timer?.cancel();
  }
}
