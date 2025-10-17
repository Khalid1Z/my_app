import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/booking.dart';

final bookingsProvider = StateNotifierProvider<BookingNotifier, List<Booking>>((
  ref,
) {
  return BookingNotifier();
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
  BookingNotifier() : super(const []);

  void addBooking(Booking booking) {
    state = [...state, booking];
  }

  void updateStatus(String bookingId, BookingStatus status) {
    state = [
      for (final booking in state)
        if (booking.id == bookingId)
          Booking(
            id: booking.id,
            serviceId: booking.serviceId,
            proId: booking.proId,
            slot: booking.slot,
            customerName: booking.customerName,
            phone: booking.phone,
            street: booking.street,
            city: booking.city,
            paymentMethod: booking.paymentMethod,
            basePrice: booking.basePrice,
            surcharge: booking.surcharge,
            total: booking.total,
            status: status,
          )
        else
          booking,
    ];
  }
}
