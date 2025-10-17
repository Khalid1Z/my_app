import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/reviews/models/review.dart';
import 'package:my_app/reviews/providers.dart';

void main() {
  group('ReviewsNotifier', () {
    test('addOrUpdate adds a fresh review', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(reviewsProvider.notifier);
      final review = Review(
        id: 'review-1',
        bookingId: 'booking-1',
        rating: 5,
        comment: 'Excellent visit',
        createdAt: DateTime.utc(2024, 1, 1),
      );

      notifier.addOrUpdate(review);

      final reviews = container.read(reviewsProvider);
      expect(reviews, hasLength(1));
      expect(reviews.single.comment, 'Excellent visit');
    });

    test('addOrUpdate replaces an existing review for the same booking', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(reviewsProvider.notifier);
      final initial = Review(
        id: 'review-1',
        bookingId: 'booking-42',
        rating: 5,
        comment: 'Great service',
        createdAt: DateTime.utc(2024, 1, 1),
      );
      final updated = Review(
        id: 'review-2',
        bookingId: 'booking-42',
        rating: 3,
        comment: 'Mixed feelings',
        createdAt: DateTime.utc(2024, 1, 2),
      );

      notifier.addOrUpdate(initial);
      notifier.addOrUpdate(updated);

      final reviews = container.read(reviewsProvider);
      expect(reviews, hasLength(1));
      expect(reviews.single.id, 'review-2');
      expect(reviews.single.rating, 3);
    });
  });

  test('reviewByBookingProvider returns matching review', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(reviewsProvider.notifier);
    final review = Review(
      id: 'review-10',
      bookingId: 'booking-10',
      rating: 4,
      comment: 'Solid experience',
      createdAt: DateTime.utc(2024, 2, 1),
    );
    notifier.addOrUpdate(review);

    final lookup = container.read(reviewByBookingProvider('booking-10'));
    expect(lookup, isNotNull);
    expect(lookup!.rating, 4);

    final missing = container.read(reviewByBookingProvider('unknown'));
    expect(missing, isNull);
  });
}
