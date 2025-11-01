import 'package:flutter/material.dart';

enum PaymentMethod { wallet, card }

enum BookingStatus { confirmed, inProgress, completed }

enum BookingExtraType { addOn, retail }

@immutable
class BookingExtra {
  const BookingExtra({
    required this.id,
    required this.label,
    required this.price,
    required this.type,
    this.description = '',
  });

  final String id;
  final String label;
  final double price;
  final BookingExtraType type;
  final String description;

  factory BookingExtra.fromJson(Map<String, dynamic> json) {
    final typeName = json['type'] as String? ?? BookingExtraType.addOn.name;
    final resolvedType = BookingExtraType.values.firstWhere(
      (value) => value.name == typeName,
      orElse: () => BookingExtraType.addOn,
    );
    return BookingExtra(
      id: json['id'] as String? ?? '',
      label: json['label'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      type: resolvedType,
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'label': label,
      'price': price,
      'type': type.name,
      'description': description,
    };
  }
}

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
    this.email = '',
    this.nationalId = '',
    this.addOns = const <BookingExtra>[],
    this.retailItems = const <BookingExtra>[],
    this.loyaltyPointsEarned = 0,
    this.instructions = '',
    this.expressBooking = false,
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
  final String email;
  final String nationalId;
  final List<BookingExtra> addOns;
  final List<BookingExtra> retailItems;
  final int loyaltyPointsEarned;
  final String instructions;
  final bool expressBooking;

  Booking copyWith({
    String? serviceId,
    String? proId,
    DateTime? slot,
    String? customerName,
    String? phone,
    String? street,
    String? city,
    PaymentMethod? paymentMethod,
    double? basePrice,
    double? surcharge,
    double? total,
    BookingStatus? status,
    String? email,
    String? nationalId,
    List<BookingExtra>? addOns,
    List<BookingExtra>? retailItems,
    int? loyaltyPointsEarned,
    String? instructions,
    bool? expressBooking,
  }) {
    return Booking(
      id: id,
      serviceId: serviceId ?? this.serviceId,
      proId: proId ?? this.proId,
      slot: slot ?? this.slot,
      customerName: customerName ?? this.customerName,
      phone: phone ?? this.phone,
      street: street ?? this.street,
      city: city ?? this.city,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      basePrice: basePrice ?? this.basePrice,
      surcharge: surcharge ?? this.surcharge,
      total: total ?? this.total,
      status: status ?? this.status,
      email: email ?? this.email,
      nationalId: nationalId ?? this.nationalId,
      addOns: addOns ?? this.addOns,
      retailItems: retailItems ?? this.retailItems,
      loyaltyPointsEarned: loyaltyPointsEarned ?? this.loyaltyPointsEarned,
      instructions: instructions ?? this.instructions,
      expressBooking: expressBooking ?? this.expressBooking,
    );
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    List<BookingExtra> _decodeExtras(dynamic value) {
      if (value is List) {
        return value
            .whereType<Map>()
            .map(
              (entry) => BookingExtra.fromJson(
                Map<String, dynamic>.from(entry as Map),
              ),
            )
            .toList();
      }
      return const <BookingExtra>[];
    }

    return Booking(
      id: json['id'] as String? ?? '',
      serviceId: json['serviceId'] as String? ?? '',
      proId: json['proId'] as String? ?? '',
      slot: DateTime.tryParse(json['slot'] as String? ?? '') ?? DateTime.now(),
      customerName: json['customerName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      street: json['street'] as String? ?? '',
      city: json['city'] as String? ?? '',
      paymentMethod: _paymentMethodFromString(json['paymentMethod']),
      basePrice: (json['basePrice'] as num?)?.toDouble() ?? 0,
      surcharge: (json['surcharge'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0,
      status: _statusFromString(json['status']),
      email: json['email'] as String? ?? '',
      nationalId: json['nationalId'] as String? ?? '',
      addOns: _decodeExtras(json['addOns']),
      retailItems: _decodeExtras(json['retailItems']),
      loyaltyPointsEarned: json['loyaltyPointsEarned'] as int? ?? 0,
      instructions: json['instructions'] as String? ?? '',
      expressBooking: json['expressBooking'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'serviceId': serviceId,
      'proId': proId,
      'slot': slot.toIso8601String(),
      'customerName': customerName,
      'phone': phone,
      'street': street,
      'city': city,
      'paymentMethod': paymentMethod.name,
      'basePrice': basePrice,
      'surcharge': surcharge,
      'total': total,
      'status': status.name,
      'email': email,
      'nationalId': nationalId,
      'addOns': addOns.map((extra) => extra.toJson()).toList(),
      'retailItems': retailItems.map((extra) => extra.toJson()).toList(),
      'loyaltyPointsEarned': loyaltyPointsEarned,
      'instructions': instructions,
      'expressBooking': expressBooking,
    };
  }

  static PaymentMethod _paymentMethodFromString(dynamic value) {
    final name = value as String? ?? PaymentMethod.wallet.name;
    return PaymentMethod.values.firstWhere(
      (method) => method.name == name,
      orElse: () => PaymentMethod.wallet,
    );
  }

  static BookingStatus _statusFromString(dynamic value) {
    final name = value as String? ?? BookingStatus.confirmed.name;
    return BookingStatus.values.firstWhere(
      (status) => status.name == name,
      orElse: () => BookingStatus.confirmed,
    );
  }
}
