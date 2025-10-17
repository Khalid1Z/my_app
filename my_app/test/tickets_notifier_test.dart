import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/tickets/models/ticket.dart';
import 'package:my_app/tickets/providers.dart';

void main() {
  group('TicketsNotifier', () {
    test('addTicket stores a new open ticket', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(ticketsProvider.notifier);

      final ticket = SupportTicket(
        id: 'ticket-1',
        bookingId: 'booking-1',
        createdAt: DateTime.utc(2024, 3, 1),
        status: TicketStatus.open,
        reason: 'Low score',
      );

      notifier.addTicket(ticket);

      final tickets = container.read(ticketsProvider);
      expect(tickets, hasLength(1));
      expect(tickets.single.reason, 'Low score');
    });

    test('addTicket ignores duplicate open ticket for the same booking', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(ticketsProvider.notifier);

      final first = SupportTicket(
        id: 'ticket-1',
        bookingId: 'booking-2',
        createdAt: DateTime.utc(2024, 4, 1),
        status: TicketStatus.open,
        reason: 'First report',
      );
      final duplicate = SupportTicket(
        id: 'ticket-2',
        bookingId: 'booking-2',
        createdAt: DateTime.utc(2024, 4, 2),
        status: TicketStatus.open,
        reason: 'Duplicate report',
      );

      notifier.addTicket(first);
      notifier.addTicket(duplicate);

      final tickets = container.read(ticketsProvider);
      expect(tickets, hasLength(1));
      expect(tickets.single.id, 'ticket-1');
    });
  });

  test('openTicketByBookingProvider only exposes open tickets', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(ticketsProvider.notifier);

    notifier.addTicket(
      const SupportTicket(
        id: 'ticket-open',
        bookingId: 'booking-3',
        createdAt: DateTime.utc(2024, 5, 1),
        status: TicketStatus.open,
        reason: 'Open issue',
      ),
    );
    final closedTicket = SupportTicket(
      id: 'ticket-closed',
      bookingId: 'booking-4',
      createdAt: DateTime.utc(2024, 5, 2),
      status: TicketStatus.closed,
      reason: 'Already resolved',
    );
    // Directly update state to simulate a closed ticket entry.
    container.read(ticketsProvider.notifier).state = [
      ...container.read(ticketsProvider),
      closedTicket,
    ];

    final openTicket = container.read(openTicketByBookingProvider('booking-3'));
    expect(openTicket, isNotNull);
    expect(openTicket!.id, 'ticket-open');

    final noTicket =
        container.read(openTicketByBookingProvider('booking-4'));
    expect(noTicket, isNull);
  });
}
