class Invoice {
  final String id;
  final String bookingId;
  final String userId;
  final String invoiceNumber;
  final double amount;
  final double tax;
  final double totalAmount;
  final String status;
  final DateTime dueDate;
  final DateTime? paidDate;
  final List<InvoiceItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  Invoice({
    required this.id,
    required this.bookingId,
    required this.userId,
    required this.invoiceNumber,
    required this.amount,
    required this.tax,
    required this.totalAmount,
    required this.status,
    required this.dueDate,
    this.paidDate,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] ?? '',
      bookingId: json['bookingId'] ?? '',
      userId: json['userId'] ?? '',
      invoiceNumber: json['invoiceNumber'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      dueDate: DateTime.parse(json['dueDate'] ?? DateTime.now().toIso8601String()),
      paidDate: json['paidDate'] != null 
          ? DateTime.parse(json['paidDate']) 
          : null,
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => InvoiceItem.fromJson(item))
          .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'userId': userId,
      'invoiceNumber': invoiceNumber,
      'amount': amount,
      'tax': tax,
      'totalAmount': totalAmount,
      'status': status,
      'dueDate': dueDate.toIso8601String(),
      'paidDate': paidDate?.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class InvoiceItem {
  final String description;
  final double quantity;
  final double unitPrice;
  final double total;

  InvoiceItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      description: json['description'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      unitPrice: (json['unitPrice'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'total': total,
    };
  }
}
