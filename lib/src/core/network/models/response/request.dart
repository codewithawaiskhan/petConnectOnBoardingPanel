import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

extension BodyBytesStream on Stream<List<int>> {
  static Stream<List<int>> fromBytes(List<int> bytes) =>
      Stream.fromIterable([bytes]);

  Future<Uint8List> toBytes() {
    var completer = Completer<Uint8List>();
    var sink = ByteConversionSink.withCallback(
      (bytes) => completer.complete(
        Uint8List.fromList(bytes),
      ),
    );
    listen(
      (val) => sink.add(val),
      onError: completer.completeError,
      onDone: sink.close,
      cancelOnError: true,
    );
    return completer.future;
  }

  Future<String> bytesToString([Encoding encoding = utf8]) =>
      encoding.decodeStream(this);
}
