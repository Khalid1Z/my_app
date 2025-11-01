import 'package:dio/dio.dart';

import 'package:my_app/pros/models/pro.dart';
import 'package:my_app/pros/pros_repository.dart';

class ProsApi implements ProsDataSource {
  ProsApi(this._dio);

  final Dio _dio;

  @override
  Future<List<Pro>> loadPros() async {
    final response = await _dio.get('/pros');
    return _parseProsResponse(response.data);
  }

  @override
  Future<List<Pro>> loadProsForService(String serviceId) async {
    final response = await _dio.get(
      '/pros',
      queryParameters: serviceId.isEmpty ? null : {'serviceId': serviceId},
    );
    return _parseProsResponse(response.data);
  }

  @override
  Future<Pro?> getProById(String proId) async {
    if (proId.isEmpty) {
      return null;
    }
    try {
      final response = await _dio.get('/pros/$proId');
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return Pro.fromJson(data);
      }
    } on DioException {
      // ignore and fall back to null
    }
    final all = await loadPros();
    for (final pro in all) {
      if (pro.id == proId) {
        return pro;
      }
    }
    return null;
  }

  List<Pro> _parseProsResponse(dynamic data) {
    if (data is List) {
      return data
          .map((entry) =>
              Pro.fromJson(Map<String, dynamic>.from(entry as Map)))
          .toList();
    }
    return const [];
  }
}
