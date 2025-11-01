import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_app/api/api_client.dart';
import 'package:my_app/api/repositories/pros_api.dart';
import 'package:my_app/config/app_config.dart';

import 'models/pro.dart';
import 'pros_repository.dart';

final prosRepositoryProvider = Provider<ProsDataSource>((ref) {
  final useMocks = ref.watch(useMocksProvider);
  if (useMocks) {
    return ProsRepository();
  }
  final dio = ref.watch(dioProvider);
  return ProsApi(dio);
});

final prosForServiceProvider = FutureProvider.family<List<Pro>, String>((
  ref,
  serviceId,
) async {
  final repository = ref.read(prosRepositoryProvider);
  final pros = await repository.loadProsForService(serviceId);
  pros.sort((a, b) => b.rating.compareTo(a.rating));
  return pros;
});

final proByIdProvider = FutureProvider.family<Pro?, String>((ref, proId) async {
  final repository = ref.read(prosRepositoryProvider);
  return repository.getProById(proId);
});

final allProsProvider = FutureProvider<List<Pro>>((ref) async {
  final repository = ref.read(prosRepositoryProvider);
  final pros = await repository.loadPros();
  pros.sort((a, b) => b.rating.compareTo(a.rating));
  return pros;
});
