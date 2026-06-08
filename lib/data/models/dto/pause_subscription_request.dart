class PauseSubscriptionRequest {
  final String reason;
  final String? customReason;

  PauseSubscriptionRequest({
    required this.reason,
    this.customReason,
  });

  Map<String, dynamic> toJson() => {
        'reason': reason,
        if (customReason != null && customReason!.isNotEmpty) 'customReason': customReason,
      };
}
