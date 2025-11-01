import 'package:flutter/foundation.dart';

@immutable
class Service {
  const Service({
    required this.id,
    required this.title,
    required this.category,
    this.subcategory,
    required this.durationMin,
    required this.basePrice,
    required this.thumbUrl,
  });

  final String id;
  final String title;
  final String category;
  final String? subcategory;
  final int durationMin;
  final double basePrice;
  final String thumbUrl;

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? '',
      subcategory: json['subcategory'] as String?,
      durationMin: (json['durationMin'] as num?)?.toInt() ?? 0,
      basePrice: (json['basePrice'] as num?)?.toDouble() ?? 0,
      thumbUrl: json['thumbUrl'] as String? ?? '',
    );
  }
}
