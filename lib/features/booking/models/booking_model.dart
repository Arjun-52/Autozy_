class Booking {
  final String id;
  final String userId;
  final String vehicleId;
  final String planId;
  final DateTime bookingDate;
  final DateTime? inspectionDate;
  final String status;
  final double totalAmount;
  final String paymentStatus;
  final Map<String, dynamic>? paymentDetails;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Booking({
    required this.id,
    required this.userId,
    required this.vehicleId,
    required this.planId,
    required this.bookingDate,
    this.inspectionDate,
    required this.status,
    required this.totalAmount,
    required this.paymentStatus,
    this.paymentDetails,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      vehicleId: json['vehicleId'] ?? '',
      planId: json['planId'] ?? '',
      bookingDate: json['bookingDate'] != null
          ? DateTime.tryParse(json['bookingDate']) ?? DateTime.now()
          : DateTime.now(),
      inspectionDate: json['inspectionDate'] != null
          ? DateTime.tryParse(json['inspectionDate'])
          : null,
      status: json['status'] ?? '',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      paymentStatus: json['paymentStatus'] ?? '',
      paymentDetails: json['paymentDetails'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'vehicleId': vehicleId,
      'planId': planId,
      'bookingDate': bookingDate.toIso8601String(),
      'inspectionDate': inspectionDate?.toIso8601String(),
      'status': status,
      'totalAmount': totalAmount,
      'paymentStatus': paymentStatus,
      'paymentDetails': paymentDetails,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Booking copyWith({
    String? id,
    String? userId,
    String? vehicleId,
    String? planId,
    DateTime? bookingDate,
    DateTime? inspectionDate,
    String? status,
    double? totalAmount,
    String? paymentStatus,
    Map<String, dynamic>? paymentDetails,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vehicleId: vehicleId ?? this.vehicleId,
      planId: planId ?? this.planId,
      bookingDate: bookingDate ?? this.bookingDate,
      inspectionDate: inspectionDate ?? this.inspectionDate,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentDetails: paymentDetails ?? this.paymentDetails,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
