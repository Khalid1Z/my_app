import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_app/api/api_client.dart';
import 'package:my_app/api/repositories/services_api.dart';
import 'package:my_app/config/app_config.dart';

import 'models/service.dart';
import 'services_repository.dart';

final servicesRepositoryProvider = Provider<ServicesDataSource>((ref) {
  final useMocks = ref.watch(useMocksProvider);
  if (useMocks) {
    return ServicesRepository();
  }
  final dio = ref.watch(dioProvider);
  return ServicesApi(dio);
});

final servicesProvider = FutureProvider<List<Service>>((ref) async {
  final repository = ref.read(servicesRepositoryProvider);
  return repository.loadServices();
});

final serviceByIdProvider = FutureProvider.family<Service?, String>((
  ref,
  id,
) async {
  final repository = ref.read(servicesRepositoryProvider);
  return repository.getServiceById(id);
});
