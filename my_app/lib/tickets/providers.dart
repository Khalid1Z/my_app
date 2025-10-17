import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/ticket.dart';

final ticketsProvider =
    StateNotifierProvider<TicketsNotifier, List<SupportTicket>>((ref) {
  return TicketsNotifier();
});

final openTicketByBookingProvider = Provider.family<SupportTicket?, String>((
  ref,
  bookingId,
) {
  final tickets = ref.watch(ticketsProvider);
  for (final ticket in tickets) {
    if (ticket.bookingId == bookingId && ticket.status == TicketStatus.open) {
      return ticket;
    }
  }
  return null;
});

class TicketsNotifier extends StateNotifier<List<SupportTicket>> {
  TicketsNotifier() : super(const []);

  void addTicket(SupportTicket ticket) {
    final hasOpenTicket = state.any((
      existing,
    ) =>
        existing.bookingId == ticket.bookingId &&
        existing.status == TicketStatus.open);
    if (hasOpenTicket) {
      return;
    }
    state = [...state, ticket];
  }
}
