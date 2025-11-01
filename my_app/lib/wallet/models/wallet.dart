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
    required this.loyaltyPoints,
    required this.nextRewardThreshold,
    required this.activeOffers,
    required this.referralCode,
    required this.referralCount,
    required this.referralBalance,
  });

  final double balance;
  final List<WalletTransaction> transactions;
  final int loyaltyPoints;
  final int nextRewardThreshold;
  final List<String> activeOffers;
  final String referralCode;
  final int referralCount;
  final double referralBalance;

  WalletState copyWith({
    double? balance,
    List<WalletTransaction>? transactions,
    int? loyaltyPoints,
    int? nextRewardThreshold,
    List<String>? activeOffers,
    String? referralCode,
    int? referralCount,
    double? referralBalance,
  }) {
    return WalletState(
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      nextRewardThreshold: nextRewardThreshold ?? this.nextRewardThreshold,
      activeOffers: activeOffers ?? this.activeOffers,
      referralCode: referralCode ?? this.referralCode,
      referralCount: referralCount ?? this.referralCount,
      referralBalance: referralBalance ?? this.referralBalance,
    );
  }
}
