import 'package:flutter/foundation.dart';

@immutable
class Review {
  const Review({
    required this.id,
    required this.bookingId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  final String id;
  final String bookingId;
  final int rating;
  final String comment;
  final DateTime createdAt;
}
