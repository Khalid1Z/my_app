import 'dart:convert';

import 'package:flutter/services.dart' show AssetBundle, rootBundle;

import 'models/service.dart';

class ServicesRepository {
  ServicesRepository({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  static const String _servicesAssetPath = 'assets/services.json';

  final AssetBundle _bundle;

  List<Service>? _cachedServices;

  Future<List<Service>> loadServices() async {
    if (_cachedServices != null) {
      return _cachedServices!;
    }
    final raw = await _bundle.loadString(_servicesAssetPath);
    final List<dynamic> decoded = json.decode(raw) as List<dynamic>;
    _cachedServices = decoded
        .map((entry) => Service.fromJson(entry as Map<String, dynamic>))
        .where((service) => service.id.isNotEmpty)
        .toList();
    return _cachedServices!;
  }

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
