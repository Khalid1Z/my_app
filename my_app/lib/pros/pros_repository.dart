import 'dart:convert';

import 'package:flutter/services.dart' show AssetBundle, rootBundle;

import 'models/pro.dart';

abstract class ProsDataSource {
  Future<List<Pro>> loadPros();
  Future<List<Pro>> loadProsForService(String serviceId);
  Future<Pro?> getProById(String proId);
}

class ProsRepository implements ProsDataSource {
  ProsRepository({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  static const String _prosAssetPath = 'assets/pros.json';

  final AssetBundle _bundle;

  List<Pro>? _cachedPros;

  @override
  Future<List<Pro>> loadPros() async {
    if (_cachedPros != null) {
      return _cachedPros!;
    }
    final raw = await _bundle.loadString(_prosAssetPath);
    final decoded = json.decode(raw) as List<dynamic>;
    _cachedPros = decoded
        .map((entry) => Pro.fromJson(entry as Map<String, dynamic>))
        .where((pro) => pro.id.isNotEmpty)
        .toList();
    return _cachedPros!;
  }

  @override
  Future<List<Pro>> loadProsForService(String serviceId) async {
    final pros = await loadPros();
    if (serviceId.isEmpty) {
      return pros;
    }
    return pros.where((pro) => pro.supportsService(serviceId)).toList();
  }

  @override
  Future<Pro?> getProById(String proId) async {
    if (proId.isEmpty) {
      return null;
    }
    final pros = await loadPros();
    try {
      return pros.firstWhere((pro) => pro.id == proId);
    } on StateError {
      return null;
    }
  }
}
