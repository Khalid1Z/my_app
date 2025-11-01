import 'dart:typed_data';

import 'package:dio/dio.dart';

final kycApiProvider = Provider<KycApi>((ref) {\n  final dio = ref.watch(dioProvider);\n  return KycApi(dio);\n});\n\nclass KycApi {
  KycApi(this._dio);

  final Dio _dio;

  Future<void> uploadDocument({
    required String fileName,
    required Uint8List bytes,
  }) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: fileName),
    });
    await _dio.post('/kyc/documents', data: formData);
  }

  Future<void> submitKyc() {
    return _dio.post('/kyc/submit');
  }
}
