import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_app/api/api_client.dart';
import 'package:my_app/bookings/models/booking.dart';

final bookingsApiProvider = Provider<BookingsApi>((ref) {
  final dio = ref.watch(dioProvider);
  return BookingsApi(dio);
});

class BookingsApi {
  BookingsApi(this._dio);

  final Dio _dio;

  Future<Booking> createBooking(Booking booking) async {
    final response = await _dio.post(
      '/bookings',
      data: booking.toJson(),
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return Booking.fromJson(Map<String, dynamic>.from(data));
    }
    return booking;
  }
}
