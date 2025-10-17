import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_app/notifications/providers.dart';

import 'models/booking.dart';

final bookingsProvider = StateNotifierProvider<BookingNotifier, List<Booking>>((
  ref,
) {
  return BookingNotifier(ref);
});

final bookingByIdProvider = Provider.family<Booking?, String>((ref, bookingId) {
  final bookings = ref.watch(bookingsProvider);
  for (final booking in bookings) {
    if (booking.id == bookingId) {
      return booking;
    }
  }
  return null;
});

class BookingNotifier extends StateNotifier<List<Booking>> {
  BookingNotifier(this._ref) : super(const []);

  final Ref _ref;

  void addBooking(Booking booking) {
    state = [...state, booking];
  }

  void updateStatus(String bookingId, BookingStatus status) {
    final previousState = state;
    state = [
      for (final booking in state)
        if (booking.id == bookingId) booking.copyWith(status: status) else booking,
    ];
    Booking? previousBooking;
    for (final booking in previousState) {
      if (booking.id == bookingId) {
        previousBooking = booking;
        break;
      }
    }
    Booking? updatedBooking;
    for (final booking in state) {
      if (booking.id == bookingId) {
        updatedBooking = booking;
        break;
      }
    }
    if (previousBooking == null || updatedBooking == null) {
      return;
    }
    final transitionedToCompleted =
        previousBooking.status != BookingStatus.completed &&
        updatedBooking.status == BookingStatus.completed;
    if (transitionedToCompleted) {
      _ref
          .read(notificationsProvider.notifier)
          .notifyReviewRequested(updatedBooking);
    }
  }
}
