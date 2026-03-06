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

  Booking({
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
      bookingDate: DateTime.parse(json['bookingDate'] ?? DateTime.now().toIso8601String()),
      inspectionDate: json['inspectionDate'] != null 
          ? DateTime.parse(json['inspectionDate']) 
          : null,
      status: json['status'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      paymentStatus: json['paymentStatus'] ?? '',
      paymentDetails: json['paymentDetails'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
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
