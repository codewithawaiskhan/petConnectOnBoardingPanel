import 'dart:collection';
import 'dart:convert';
import 'http_status.dart';
import 'request.dart';

class Response<T> {
  const Response({
    this.statusCode,
    this.bodyBytes,
    this.bodyString,
    this.statusText = '',
    this.headers = const {},
    this.body,
  });

  final Map<String, String>? headers;

  final int? statusCode;

  final String? statusText;

  HttpStatus get status => HttpStatus(statusCode);

  bool get hasError => status.hasError;

  bool get isOk => !hasError;

  bool get unauthorized => status.isUnauthorized;

  final Stream<List<int>>? bodyBytes;

  final String? bodyString;

  final T? body;
}

Future<String> bodyBytesToString(
  Stream<List<int>> bodyBytes,
  Map<String, String> headers,
) {
  return bodyBytes.bytesToString(_encodingForHeaders(headers));
}

Encoding _encodingForHeaders(Map<String, String> headers) =>
    _encodingForCharset(_contentTypeForHeaders(headers).parameters?['charset']);

Encoding _encodingForCharset(String? charset, [Encoding fallback = utf8]) {
  if (charset == null) return fallback;
  return Encoding.getByName(charset) ?? fallback;
}

HeaderValue _contentTypeForHeaders(Map<String, String> headers) {
  var contentType = headers['content-type'];
  if (contentType != null) return HeaderValue.parse(contentType);
  return HeaderValue('application/octet-stream');
}

class HeaderValue {
  String _value;
  Map<String, String?>? _parameters;
  Map<String, String?>? _unmodifiableParameters;

  HeaderValue([this._value = '', Map<String, String>? parameters]) {
    if (parameters != null) {
      _parameters = HashMap<String, String>.from(parameters);
    }
  }

  static HeaderValue parse(
    String value, {
    String parameterSeparator = ';',
    String? valueSeparator,
    bool preserveBackslash = false,
  }) {
    var result = HeaderValue();
    result._parse(value, parameterSeparator, valueSeparator, preserveBackslash);
    return result;
  }

  String get value => _value;

  void _ensureParameters() {
    _parameters ??= HashMap<String, String>();
  }

  Map<String, String?>? get parameters {
    _ensureParameters();
    _unmodifiableParameters ??= UnmodifiableMapView(_parameters!);
    return _unmodifiableParameters;
  }

  @override
  String toString() {
    var stringBuffer = StringBuffer();
    stringBuffer.write(_value);
    if (parameters != null && parameters!.isNotEmpty) {
      _parameters!.forEach((name, value) {
        stringBuffer
          ..write('; ')
          ..write(name)
          ..write('=')
          ..write(value);
      });
    }
    return stringBuffer.toString();
  }

  void _parse(
    String value,
    String parameterSeparator,
    String? valueSeparator,
    bool preserveBackslash,
  ) {
    var index = 0;

    bool done() => index == value.length;

    void bump() {
      while (!done()) {
        if (value[index] != ' ' && value[index] != '\t') return;
        index++;
      }
    }

    String parseValue() {
      var start = index;
      while (!done()) {
        if (value[index] == ' ' ||
            value[index] == '\t' ||
            value[index] == valueSeparator ||
            value[index] == parameterSeparator) {
          break;
        }
        index++;
      }
      return value.substring(start, index);
    }

    void expect(String expected) {
      if (done() || value[index] != expected) {
        throw StateError('Failed to parse header value');
      }
      index++;
    }

    void maybeExpect(String expected) {
      if (value[index] == expected) index++;
    }

    void parseParameters() {
      var parameters = HashMap<String, String?>();
      _parameters = UnmodifiableMapView(parameters);

      String parseParameterName() {
        var start = index;
        while (!done()) {
          if (value[index] == ' ' ||
              value[index] == '\t' ||
              value[index] == '=' ||
              value[index] == parameterSeparator ||
              value[index] == valueSeparator) {
            break;
          }
          index++;
        }
        return value.substring(start, index).toLowerCase();
      }

      String? parseParameterValue() {
        if (!done() && value[index] == '"') {
          var stringBuffer = StringBuffer();
          index++;
          while (!done()) {
            if (value[index] == '\\') {
              if (index + 1 == value.length) {
                throw StateError('Failed to parse header value');
              }
              if (preserveBackslash && value[index + 1] != '"') {
                stringBuffer.write(value[index]);
              }
              index++;
            } else if (value[index] == '"') {
              index++;
              break;
            }
            stringBuffer.write(value[index]);
            index++;
          }
          return stringBuffer.toString();
        } else {
          var val = parseValue();
          return val == '' ? null : val;
        }
      }

      while (!done()) {
        bump();
        if (done()) return;
        var name = parseParameterName();
        bump();
        if (done()) {
          parameters[name] = null;
          return;
        }
        maybeExpect('=');
        bump();
        if (done()) {
          parameters[name] = null;
          return;
        }
        var valueParameter = parseParameterValue();
        if (name == 'charset' && valueParameter != null) {
          valueParameter = valueParameter.toLowerCase();
        }
        parameters[name] = valueParameter;
        bump();
        if (done()) return;
        if (value[index] == valueSeparator) return;
        expect(parameterSeparator);
      }
    }

    bump();
    _value = parseValue();
    bump();
    if (done()) return;
    maybeExpect(parameterSeparator);
    parseParameters();
  }
}
