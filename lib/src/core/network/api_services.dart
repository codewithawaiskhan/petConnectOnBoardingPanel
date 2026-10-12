import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../error/app_exceptions.dart';
import 'models/response/response.dart';

class ApiServices {
  static const String noInternetMessage = 'Connection to API server failed due to internet connection';
  final int timeoutInSeconds = 30;

  String? token;
  Map<String, String>? _mainHeaders;

  void updateHeader(String token) {
    this.token = token.trim();
    _mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };
    if (this.token != null && this.token!.isNotEmpty && this.token != 'null') {
      _mainHeaders!['Authorization'] = 'Bearer ${this.token!.replaceFirst('Bearer ', '').trim()}';
    }
  }

  Map<String, String> _resolveHeaders(Map<String, String>? headers, {bool isJson = true}) {
    final Map<String, String> resolved = {
      if (isJson) 'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      ...?_mainHeaders,
      ...?headers,
    };

    if (token != null && token!.trim().isNotEmpty && token != 'null') {
      resolved['Authorization'] = 'Bearer ${token!.replaceFirst('Bearer ', '').trim()}';
    }

    final auth = resolved['Authorization'];
    if (auth != null) {
      final tokenPart = auth.replaceFirst('Bearer ', '').trim();
      if (tokenPart.isEmpty || tokenPart == 'null') {
        resolved.remove('Authorization');
      }
    }
    return resolved;
  }

  Future<Response> getData(String uri, {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    final finalHeaders = _resolveHeaders(headers, isJson: false);
    return _safeApiCall(
      uri: uri,
      request: () => http.get(Uri.parse(uri), headers: finalHeaders),
    );
  }

  Future<Response> postData(String uri, dynamic body, {Map<String, String>? headers}) async {
    final finalHeaders = _resolveHeaders(headers, isJson: true);
    final String encodedBody = body is String ? body : jsonEncode(body);
    return _safeApiCall(
      uri: uri,
      body: encodedBody,
      request: () => http.post(Uri.parse(uri), body: encodedBody, headers: finalHeaders),
    );
  }

  Future<Response> patchData(String uri, dynamic body, {Map<String, String>? headers}) async {
    final finalHeaders = _resolveHeaders(headers, isJson: true);
    final String encodedBody = body is String ? body : jsonEncode(body);
    return _safeApiCall(
      uri: uri,
      body: encodedBody,
      request: () => http.patch(Uri.parse(uri), body: encodedBody, headers: finalHeaders),
    );
  }

  Future<Response> putData(String uri, dynamic body, {Map<String, String>? headers}) async {
    final finalHeaders = _resolveHeaders(headers, isJson: true);
    final String encodedBody = body is String ? body : jsonEncode(body);
    return _safeApiCall(
      uri: uri,
      body: encodedBody,
      request: () => http.put(Uri.parse(uri), body: encodedBody, headers: finalHeaders),
    );
  }

  Future<Response> deleteData(String uri, {dynamic body, Map<String, String>? headers}) async {
    final finalHeaders = _resolveHeaders(headers, isJson: body != null);
    final dynamic encodedBody = body != null ? (body is String ? body : jsonEncode(body)) : null;
    return _safeApiCall(
      uri: uri,
      body: encodedBody,
      request: () => http.delete(
        Uri.parse(uri),
        body: encodedBody,
        headers: finalHeaders,
      ),
    );
  }

  Future<Response> putMultipartData(
    String uri,
    Map<String, String> body,
    List<MultipartBody> multipartBody, {
    Map<String, String>? headers,
  }) async {
    return _safeApiCall(
      uri: uri,
      body: body,
      request: () async {
        http.MultipartRequest request = http.MultipartRequest('PUT', Uri.parse(uri));
        final finalHeaders = _resolveHeaders(headers, isJson: false);
        request.headers.addAll(finalHeaders);

        for (MultipartBody multipart in multipartBody) {
          final bytes = await multipart.file.readAsBytes();
          request.files.add(
            http.MultipartFile.fromBytes(
              multipart.key,
              bytes,
              filename: multipart.file.name,
              contentType: MediaType('image', 'jpeg'),
            ),
          );
        }
        request.fields.addAll(body);
        return await http.Response.fromStream(await request.send());
      },
    );
  }

  Future<Response> _safeApiCall({
    required String uri,
    dynamic body,
    required Future<http.Response> Function() request,
  }) async {
    try {
      if (kDebugMode) debugPrint('====> API Call: $uri\nToken: $token');
      if (body != null && kDebugMode) debugPrint('====> API Body: $body');

      http.Response response0 = await request().timeout(Duration(seconds: timeoutInSeconds));
      Response response = handleResponse(response0);

      if (kDebugMode) debugPrint('====> API Response: [${response.statusCode}] $uri\n${response.body}');

      return response;
    } on http.ClientException {
      throw NetworkException("No Internet connection. Please check your network.");
    } on TimeoutException {
      throw NetworkException("Connection timed out. Please try again.");
    } catch (e) {
      if (e.toString().contains('SocketException') || e.toString().contains('ClientException')) {
        throw NetworkException("No Internet connection. Please check your network.");
      }
      if (kDebugMode) debugPrint('====> API Error in $uri: $e');
      if (e is AppException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  Response handleResponse(http.Response response) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (e) {
      body = null;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Response(
        body: body ?? response.body,
        bodyString: response.body.toString(),
        headers: response.headers,
        statusCode: response.statusCode,
        statusText: response.reasonPhrase,
      );
    }

    // Error extract
    String? finalMessage;
    dynamic rawMessage;

    if (body != null && body["data"] != null && body["data"]["message"] != null) {
      rawMessage = body["data"]["message"];
    } else if (body != null && body["message"] != null) {
      rawMessage = body["message"];
    } else if (body != null && body["data"] != null && body["data"]["error"] != null) {
      rawMessage = body["data"]["error"];
    } else if (body != null && body["error"] != null) {
      rawMessage = body["error"];
    }

    if (rawMessage is String) {
      finalMessage = rawMessage;
    } else if (rawMessage is List) {
      finalMessage = rawMessage.join(', ');
    } else if (rawMessage is Map) {
      if (rawMessage.values.isNotEmpty) {
        finalMessage = rawMessage.values.first.toString();
      }
    } else if (rawMessage != null) {
      finalMessage = rawMessage.toString();
    }

    if (response.statusCode == 401) {
      throw UnauthorizedException(finalMessage ?? "Session expired", 401);
    } else if (response.statusCode == 403) {
      throw ForbiddenException(finalMessage ?? "Access denied", 403);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw BadRequestException(finalMessage ?? "Invalid request", response.statusCode);
    } else if (response.statusCode >= 500) {
      throw ServerException("Server error (${response.statusCode}) Please try again later", response.statusCode);
    } else {
      throw UnknownException("Something went wrong");
    }
  }
}

class MultipartBody {
  String key;
  XFile file;

  MultipartBody(this.key, this.file);
}
