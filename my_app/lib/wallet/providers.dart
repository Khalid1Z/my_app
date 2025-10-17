import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/wallet.dart';

final walletProvider =
    StateNotifierProvider<WalletNotifier, WalletState>((ref) {
  return WalletNotifier();
});

class WalletNotifier extends StateNotifier<WalletState> {
  WalletNotifier()
      : super(
          WalletState(
            balance: 250,
            transactions: const [],
          ),
        );

  void topUp(double amount, {String description = 'Wallet top-up'}) {
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

  void charge(double amount, {required String description}) {
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
  }
}
