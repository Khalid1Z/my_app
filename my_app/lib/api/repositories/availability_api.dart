import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_app/api/api_client.dart';

final availabilityApiProvider = Provider<AvailabilityApi>((ref) {
  final dio = ref.watch(dioProvider);
  return AvailabilityApi(dio);
});

class AvailabilityApi {
  AvailabilityApi(this._dio);

  final Dio _dio;

  Future<List<DateTime>> fetchAvailability({
    required String serviceId,
    required String proId,
  }) async {
    final response = await _dio.get(
      '/availability',
      queryParameters: {
        if (serviceId.isNotEmpty) 'serviceId': serviceId,
        if (proId.isNotEmpty) 'proId': proId,
      },
    );
    final data = response.data;
    if (data is List) {
      return data
          .whereType<String>()
          .map(DateTime.tryParse)
          .whereType<DateTime>()
          .toList();
    }
    return const [];
  }
}
