import 'package:flutter/foundation.dart';

enum TicketStatus { open, closed }

@immutable
class SupportTicket {
  const SupportTicket({
    required this.id,
    required this.bookingId,
    required this.createdAt,
    required this.status,
    required this.reason,
  });

  final String id;
  final String bookingId;
  final DateTime createdAt;
  final TicketStatus status;
  final String reason;
}
