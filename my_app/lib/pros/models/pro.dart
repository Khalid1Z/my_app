import 'package:flutter/foundation.dart';

@immutable
class Pro {
  const Pro({
    required this.id,
    required this.name,
    required this.rating,
    required this.skills,
    required this.photoUrl,
    required this.baseLocation,
  });

  final String id;
  final String name;
  final double rating;
  final List<String> skills;
  final String photoUrl;
  final GeoPoint baseLocation;

  factory Pro.fromJson(Map<String, dynamic> json) {
    return Pro(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      skills: (json['skills'] as List<dynamic>? ?? const [])
          .map((value) => value.toString())
          .toList(),
      photoUrl: json['photoUrl'] as String? ?? '',
      baseLocation: GeoPoint.fromJson(
        json['baseLocation'] as Map<String, dynamic>?,
      ),
    );
  }

  bool supportsService(String serviceId) =>
      skills.contains(serviceId) || serviceId.isEmpty;
}

@immutable
class GeoPoint {
  const GeoPoint({required this.lat, required this.lng});

  final double lat;
  final double lng;

  factory GeoPoint.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const GeoPoint(lat: 0, lng: 0);
    }
    return GeoPoint(
      lat: (json['lat'] as num?)?.toDouble() ?? 0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0,
    );
  }
}
