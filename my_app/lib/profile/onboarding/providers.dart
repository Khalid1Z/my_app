import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProOnboardingStep {
  const ProOnboardingStep({
    required this.id,
    required this.label,
    required this.isComplete,
  });

  final String id;
  final String label;
  final bool isComplete;

  ProOnboardingStep copyWith({bool? isComplete}) {
    return ProOnboardingStep(
      id: id,
      label: label,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}

final proOnboardingProvider =
    StateNotifierProvider<ProOnboardingNotifier, List<ProOnboardingStep>>((ref) {
  return ProOnboardingNotifier(const [
    ProOnboardingStep(
      id: 'documents',
      label: 'Upload certification documents',
      isComplete: false,
    ),
    ProOnboardingStep(
      id: 'availability',
      label: 'Set weekly availability',
      isComplete: false,
    ),
    ProOnboardingStep(
      id: 'training',
      label: 'Complete safety training module',
      isComplete: false,
    ),
  ]);
});

class ProOnboardingNotifier extends StateNotifier<List<ProOnboardingStep>> {
  ProOnboardingNotifier(super.initial);

  void toggleStep(String id, bool isComplete) {
    state = [
      for (final step in state)
        if (step.id == id) step.copyWith(isComplete: isComplete) else step,
    ];
  }

  void reset() {
    state = [
      for (final step in state) step.copyWith(isComplete: false),
    ];
  }
}
