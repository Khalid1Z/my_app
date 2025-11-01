import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_app/api/repositories/wallet_api.dart';
import 'package:my_app/config/app_config.dart';
import 'package:my_app/notifications/providers.dart';

import 'models/wallet.dart';

final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((
  ref,
) {
  return WalletNotifier(ref);
});

class WalletNotifier extends StateNotifier<WalletState> {
  WalletNotifier(this._ref)
    : super(
        WalletState(
          balance: 250,
          transactions: const [],
          loyaltyPoints: 320,
          nextRewardThreshold: 500,
          activeOffers: const [
            '10% off evening bookings this month',
            'Free travel fee after 3 more visits',
          ],
          referralCode: 'BEAUTY-AR23',
          referralCount: 4,
          referralBalance: 120,
        ),
      );

  final Ref _ref;

  Future<void> topUp(
    double amount, {
    String description = 'Wallet top-up',
  }) async {
    final transaction = WalletTransaction(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: WalletTransactionType.topUp,
      amount: amount,
      description: description,
      timestamp: DateTime.now(),
    );
    state = state.copyWith(
      balance: state.balance + amount,
      transactions: [transaction, ...state.transactions],
    );
  }

  void addLoyaltyPoints(int points, {String source = 'booking'}) {
    if (points <= 0) {
      return;
    }
    final updatedPoints = state.loyaltyPoints + points;
    var updatedThreshold = state.nextRewardThreshold;
    final updatedOffers = List<String>.from(state.activeOffers);
    if (updatedPoints >= state.nextRewardThreshold) {
      updatedThreshold += 500;
      if (!updatedOffers.contains('Unlocked: -20% on next facial')) {
        updatedOffers.add('Unlocked: -20% on next facial');
      }
    }
    state = state.copyWith(
      loyaltyPoints: updatedPoints,
      nextRewardThreshold: updatedThreshold,
      activeOffers: updatedOffers,
    );
    _ref
        .read(notificationsProvider.notifier)
        .notifyLoyaltyUpdated(points: updatedPoints, source: source);
  }

  void recordReferral({double bonus = 50}) {
    final newCount = state.referralCount + 1;
    state = state.copyWith(
      referralCount: newCount,
      referralBalance: state.referralBalance + bonus,
    );
  }

  Future<void> charge(double amount, {required String description}) async {
    final useMocks = _ref.read(useMocksProvider);
    if (!useMocks) {
      await _ref
          .read(walletApiProvider)
          .charge(amount: amount, description: description);
    }
    final transaction = WalletTransaction(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: WalletTransactionType.charge,
      amount: -amount,
      description: description,
      timestamp: DateTime.now(),
    );
    state = state.copyWith(
      balance: state.balance - amount,
      transactions: [transaction, ...state.transactions],
    );
    _ref
        .read(notificationsProvider.notifier)
        .notifyWalletCharged(amount: amount, description: description);
  }
}
