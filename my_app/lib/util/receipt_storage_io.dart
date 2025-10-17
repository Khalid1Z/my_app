import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

Future<String> saveReceiptImpl(Uint8List bytes, String bookingId) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/receipt_$bookingId.pdf');
  await file.writeAsBytes(bytes, flush: true);
  return file.path;
}
