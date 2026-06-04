
class PaginationMeta {
  final int? total;
  final int? page;
  final int? limit;
  final int? totalPages;

  PaginationMeta({
    this.total,
    this.page,
    this.limit,
    this.totalPages,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      total: json['total'] != null ? int.tryParse(json['total'].toString()) : null,
      page: json['page'] != null ? int.tryParse(json['page'].toString()) : null,
      limit: json['limit'] != null ? int.tryParse(json['limit'].toString()) : null,
      totalPages: json['totalPages'] != null ? int.tryParse(json['totalPages'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'total': total,
        'page': page,
        'limit': limit,
        'totalPages': totalPages,
      };
}
