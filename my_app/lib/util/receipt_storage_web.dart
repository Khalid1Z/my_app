import 'dart:typed_data';
import 'dart:html' as html;

Future<String> saveReceiptImpl(Uint8List bytes, String bookingId) async {
  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', 'receipt_$bookingId.pdf')
    ..style.display = 'none';
  html.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
  html.Url.revokeObjectUrl(url);
  return '';
}
