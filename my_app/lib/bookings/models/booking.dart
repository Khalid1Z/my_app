import 'package:flutter/material.dart';

enum PaymentMethod { wallet, card }

enum BookingStatus { confirmed, inProgress, completed }

@immutable
class Booking {
  const Booking({
    required this.id,
    required this.serviceId,
    required this.proId,
    required this.slot,
    required this.customerName,
    required this.phone,
    required this.street,
    required this.city,
    required this.paymentMethod,
    required this.basePrice,
    required this.surcharge,
    required this.total,
    required this.status,
  });

  final String id;
  final String serviceId;
  final String proId;
  final DateTime slot;
  final String customerName;
  final String phone;
  final String street;
  final String city;
  final PaymentMethod paymentMethod;
  final double basePrice;
  final double surcharge;
  final double total;
  final BookingStatus status;
}
