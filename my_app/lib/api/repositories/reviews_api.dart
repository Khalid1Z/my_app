import 'package:dio/dio.dart';

import 'package:my_app/reviews/models/review.dart';

final reviewsApiProvider = Provider<ReviewsApi>((ref) {\n  final dio = ref.watch(dioProvider);\n  return ReviewsApi(dio);\n});\n\nclass ReviewsApi {
  ReviewsApi(this._dio);

  final Dio _dio;

  Future<void> submitReview(Review review) {
    return _dio.post('/reviews', data: _payload(review));
  }

  Map<String, dynamic> _payload(Review review) {
    return {
      'bookingId': review.bookingId,
      'rating': review.rating,
      'comment': review.comment,
      'createdAt': review.createdAt.toIso8601String(),
    };
  }
}
