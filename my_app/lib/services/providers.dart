import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/service.dart';
import 'services_repository.dart';

final servicesRepositoryProvider = Provider<ServicesRepository>((ref) {
  return ServicesRepository();
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
