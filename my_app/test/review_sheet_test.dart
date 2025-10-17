import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/bookings/models/booking.dart';
import 'package:my_app/main.dart';
import 'package:my_app/pros/models/pro.dart';
import 'package:my_app/pros/providers.dart';
import 'package:my_app/reviews/providers.dart';
import 'package:my_app/services/models/service.dart';
import 'package:my_app/services/providers.dart';
import 'package:my_app/tickets/providers.dart';

void main() {
  const bookingId = 'booking-99';
  final completedBooking = Booking(
    id: bookingId,
    serviceId: 'service-1',
    proId: 'pro-1',
    slot: DateTime.utc(2024, 6, 1, 9),
    customerName: 'Alex Doe',
    phone: '555-0100',
    street: '123 Market St',
    city: 'Springfield',
    paymentMethod: PaymentMethod.card,
    basePrice: 120,
    surcharge: 0,
    total: 120,
    status: BookingStatus.completed,
  );
  final testService = Service(
    id: 'service-1',
    title: 'Deep Clean',
    category: 'Cleaning',
    durationMin: 120,
    basePrice: 120,
    thumbUrl: '',
  );
  final testPro = Pro(
    id: 'pro-1',
    name: 'Jordan Smith',
    rating: 4.9,
    skills: const ['service-1'],
    photoUrl: '',
    baseLocation: const GeoPoint(lat: 12.34, lng: 56.78),
  );

  ProviderContainer _createContainer() {
    return ProviderContainer(overrides: [
      serviceByIdProvider.overrideWith((ref, id) async {
        if (id == testService.id) {
          return testService;
        }
        return null;
      }),
      proByIdProvider.overrideWith((ref, id) async {
        if (id == testPro.id) {
          return testPro;
        }
        return null;
      }),
    ]);
  }

  Future<void> _openReviewSheet(
    WidgetTester tester,
    ProviderContainer container,
  ) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => ReviewSheet(
                        booking: completedBooking,
                      ),
                    );
                  },
                  child: const Text('Open review'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open review'));
    await tester.pumpAndSettle();
  }

  group('ReviewSheet', () {
    testWidgets('saves a review without opening a ticket', (tester) async {
      final container = _createContainer();
      addTearDown(container.dispose);

      await _openReviewSheet(tester, container);

      await tester.enterText(
        find.byType(TextField),
        'Everything was spotless!',
      );
      await tester.tap(find.text('Submit review'));
      await tester.pumpAndSettle();

      final reviews = container.read(reviewsProvider);
      expect(reviews, hasLength(1));
      expect(reviews.single.bookingId, bookingId);
      expect(reviews.single.rating, 5);

      final tickets = container.read(ticketsProvider);
      expect(tickets, isEmpty);
    });

    testWidgets('creates a ticket when rating is below three', (tester) async {
      final container = _createContainer();
      addTearDown(container.dispose);

      await _openReviewSheet(tester, container);

      // Select a low rating.
      await tester.tap(find.byIcon(Icons.star).at(1));
      await tester.pump();

      await tester.enterText(
        find.byType(TextField),
        'The pro arrived late.',
      );
      await tester.tap(find.text('Submit review'));
      await tester.pumpAndSettle();

      final reviews = container.read(reviewsProvider);
      expect(reviews, hasLength(1));
      expect(reviews.single.rating, lessThan(3));

      final tickets = container.read(ticketsProvider);
      expect(tickets, hasLength(1));
      expect(tickets.single.bookingId, bookingId);
      expect(tickets.single.reason, contains('late'));
    });
  });
}
