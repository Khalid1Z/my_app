import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_app/api/api_client.dart';

final walletApiProvider = Provider<WalletApi>((ref) {
  final dio = ref.watch(dioProvider);
  return WalletApi(dio);
});

class WalletApi {
  WalletApi(this._dio);

  final Dio _dio;

  Future<void> charge({
    required double amount,
    required String description,
  }) {
    return _dio.post(
      '/wallet/charge',
      data: <String, dynamic>{
        'amount': amount,
        'description': description,
      },
    );
  }
}
