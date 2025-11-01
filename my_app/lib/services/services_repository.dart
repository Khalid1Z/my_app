import 'dart:convert';

import 'package:flutter/services.dart' show AssetBundle, rootBundle;

import 'models/service.dart';

abstract class ServicesDataSource {
  Future<List<Service>> loadServices();
  Future<Service?> getServiceById(String id);
}

class ServicesRepository implements ServicesDataSource {
  ServicesRepository({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  static const String _servicesAssetPath = 'assets/services.json';

  final AssetBundle _bundle;

  List<Service>? _cachedServices;

  @override
  Future<List<Service>> loadServices() async {
    if (_cachedServices != null) {
      return _cachedServices!;
    }
    final raw = await _bundle.loadString(_servicesAssetPath);
    final decoded = json.decode(raw);
    final services = <Service>[];

    void addFromMap(Map<String, dynamic> map) {
      final service = Service.fromJson(map);
      if (service.id.isNotEmpty) {
        services.add(service);
      }
    }

    if (decoded is List) {
      for (final entry in decoded) {
        if (entry is Map<String, dynamic>) {
          addFromMap(entry);
        }
      }
    } else if (decoded is Map) {
      decoded.forEach((_, subcategories) {
        if (subcategories is Map) {
          subcategories.forEach((__, items) {
            if (items is List) {
              for (final item in items) {
                if (item is Map) {
                  final map = Map<String, dynamic>.from(item as Map);
                  addFromMap(map);
                }
              }
            }
          });
        }
      });
    }
    _cachedServices = services;
    return _cachedServices!;
  }

  @override
  Future<Service?> getServiceById(String id) async {
    if (id.isEmpty) {
      return null;
    }
    final services = await loadServices();
    try {
      return services.firstWhere((service) => service.id == id);
    } on StateError {
      return null;
    }
  }
}
