import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/review.dart';

final reviewsProvider =
    StateNotifierProvider<ReviewsNotifier, List<Review>>((ref) {
  return ReviewsNotifier();
});

final reviewByBookingProvider = Provider.family<Review?, String>((
  ref,
  bookingId,
) {
  final reviews = ref.watch(reviewsProvider);
  for (final review in reviews) {
    if (review.bookingId == bookingId) {
      return review;
    }
  }
  return null;
});

class ReviewsNotifier extends StateNotifier<List<Review>> {
  ReviewsNotifier() : super(const []);

  void addOrUpdate(Review review) {
    final existingIndex = state.indexWhere(
      (element) => element.bookingId == review.bookingId,
    );
    if (existingIndex == -1) {
      state = [...state, review];
      return;
    }
    final updated = [...state];
    updated[existingIndex] = review;
    state = updated;
  }
}
