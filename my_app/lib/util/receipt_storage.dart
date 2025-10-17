import 'dart:typed_data';

import 'receipt_storage_stub.dart'
    if (dart.library.io) 'receipt_storage_io.dart'
    if (dart.library.html) 'receipt_storage_web.dart';

Future<String> saveReceipt(Uint8List bytes, String bookingId) {
  return saveReceiptImpl(bytes, bookingId);
}
