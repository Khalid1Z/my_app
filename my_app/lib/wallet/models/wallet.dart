import 'package:flutter/material.dart';

enum WalletTransactionType { topUp, charge }

@immutable
class WalletTransaction {
  const WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.timestamp,
  });

  final String id;
  final WalletTransactionType type;
  final double amount;
  final String description;
  final DateTime timestamp;

  bool get isCredit => type == WalletTransactionType.topUp;
}

@immutable
class WalletState {
  const WalletState({
    required this.balance,
    required this.transactions,
  });

  final double balance;
  final List<WalletTransaction> transactions;

  WalletState copyWith({
    double? balance,
    List<WalletTransaction>? transactions,
  }) {
    return WalletState(
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
    );
  }
}
