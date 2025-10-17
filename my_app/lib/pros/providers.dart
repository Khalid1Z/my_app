import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/pro.dart';
import 'pros_repository.dart';

final prosRepositoryProvider = Provider<ProsRepository>((ref) {
  return ProsRepository();
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
