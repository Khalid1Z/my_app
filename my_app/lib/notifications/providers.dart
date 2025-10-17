import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/bookings/models/booking.dart';

import 'models/notification_entry.dart';

final notificationsProvider = StateNotifierProvider<NotificationsNotifier,
    List<NotificationEntry>>((ref) {
  return NotificationsNotifier();
});

class NotificationsNotifier extends StateNotifier<List<NotificationEntry>> {
  NotificationsNotifier() : super(const []);

  static String _formatDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '${local.month}/${local.day}/${local.year} $hour:$minute';
  }

  void addNotification(NotificationEntry entry) {
    state = [entry, ...state];
  }

  void notifyBookingConfirmed({
    required Booking booking,
    required String serviceTitle,
    required String proName,
  }) {
    final slotLabel = _formatDateTime(booking.slot);
    addNotification(
      NotificationEntry(
        id: _generateId(),
        title: 'Booking confirmed',
        body: '$serviceTitle with $proName on $slotLabel',
        timestamp: DateTime.now(),
        type: NotificationType.booking,
        isRead: false,
      ),
    );
  }

  void notifyWalletCharged({
    required double amount,
    required String description,
  }) {
    final formattedAmount = amount.abs().toStringAsFixed(2);
    addNotification(
      NotificationEntry(
        id: _generateId(),
        title: 'Wallet charged',
        body: '$description · -\$$formattedAmount',
        timestamp: DateTime.now(),
        type: NotificationType.wallet,
        isRead: false,
      ),
    );
  }

  void notifyReviewRequested(Booking booking) {
    final slotLabel = _formatDateTime(booking.slot);
    addNotification(
      NotificationEntry(
        id: _generateId(),
        title: 'Review requested',
        body: 'Share feedback for your visit on $slotLabel.',
        timestamp: DateTime.now(),
        type: NotificationType.review,
        isRead: false,
      ),
    );
  }

  void markAllRead() {
    state = [
      for (final entry in state) entry.copyWith(isRead: true),
    ];
  }

  void markRead(String id) {
    state = [
      for (final entry in state)
        if (entry.id == id) entry.copyWith(isRead: true) else entry,
    ];
  }

  static String _generateId() =>
      'notification-${DateTime.now().microsecondsSinceEpoch}';
}
