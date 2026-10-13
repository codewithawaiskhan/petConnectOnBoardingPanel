import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/config/api_endpoints.dart';

class MiniFunctions {
  static String formatAmount(
    String amount, {
    bool useCommaSeparator = false,
    bool alwaysOneDecimals = false,
  }) {
    double value = double.tryParse(amount) ?? 0;

    String formatted;

    if (alwaysOneDecimals) {
      formatted = value.toStringAsFixed(1);
    } else {
      formatted = value % 1 == 0
          ? value.toStringAsFixed(0)
          : value.toStringAsFixed(2);
    }

    if (useCommaSeparator) {
      if (alwaysOneDecimals) {
        final numberFormat = NumberFormat("#,##0.0");
        formatted = numberFormat.format(value);
      } else {
        final numberFormat = NumberFormat("#,##0.##");
        formatted = numberFormat.format(value);
      }
    }
    if (formatted.contains('.')) {
      formatted = formatted.replaceAll(RegExp(r'0*$'), '');
      formatted = formatted.replaceAll(RegExp(r'\.$'), '');
    }
    if (formatted.endsWith('.0')) {
      formatted = formatted.substring(0, formatted.length - 2);
    }
    return formatted;
  }

  static String convertDateTimeToIsoUtc(String input) {
    DateFormat inputFormat = DateFormat('dd/MM/yyyy HH:mm');
    DateTime localDate = inputFormat.parse(input);
    DateTime utcDate = localDate.toUtc();
    return utcDate.toIso8601String();
  }

  static String normalizeString(String value) {
    return value.toLowerCase().trim().replaceAll(RegExp(r'\s+'), '_');
  }

  static String formatDisplayString(
    String value, {
    bool capitalizeEveryWord = false,
  }) {
    if (value.isEmpty) return '';
    String formatted = value.replaceAll('_', ' ');

    if (capitalizeEveryWord) {
      return formatted
          .split(' ')
          .map((word) {
            if (word.isEmpty) return '';
            return '${word[0].toUpperCase()}${word.substring(1)}';
          })
          .join(' ');
    }
    return '${formatted[0].toUpperCase()}${formatted.substring(1)}';
  }

  String getAge(String? dobString, {bool showYear = true}) {
    if (dobString == null || dobString.isEmpty) {
      return showYear ? "0 year" : "0";
    }

    try {
      final dob = DateTime.parse(dobString);
      final now = DateTime.now();
      final age =
          now.year -
          dob.year -
          ((now.month < dob.month ||
                  (now.month == dob.month && now.day < dob.day))
              ? 1
              : 0);
      return showYear ? "$age year" : "$age";
    } catch (e) {
      return showYear ? "0 year" : "0";
    }
  }

  Future<String> convertNetworkImageToBase64(String imageUrl) async {
    if (imageUrl.isEmpty) {
      return "";
    }
    if (imageUrl.startsWith("data:image") && imageUrl.contains("base64,")) {
      return imageUrl;
    }
    String fullImageUrl = imageUrl.startsWith("http")
        ? imageUrl
        : "${ApiEndpoints.baseUrl}/$imageUrl";
    final response = await http.get(Uri.parse(fullImageUrl));

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final base64Image = base64Encode(bytes);
      return 'data:image/jpeg;base64,$base64Image';
    } else {
      return "";
    }
  }

  static String getDaysLeft(String? date) {
    if (date == null || date.trim().isEmpty) return "";

    try {
      final targetDate = DateTime.parse(date).toLocal();
      final days = targetDate.difference(DateTime.now()).inDays;

      return "$days day${days == 1 ? "" : "s"} left";
    } catch (_) {
      return "";
    }
  }

  Future<String> convertAttachmentToBase64(String attachment) async {
    if (attachment.isEmpty) return "";

    if (attachment.startsWith("data:")) {
      return attachment;
    }

    try {
      final url = attachment.startsWith("http")
          ? attachment
          : "${ApiEndpoints.baseUrl}/$attachment";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        String base64 = base64Encode(response.bodyBytes);

        String mimeType = "application/octet-stream";
        if (attachment.toLowerCase().endsWith('.pdf')) {
          mimeType = "application/pdf";
        } else if (attachment.toLowerCase().endsWith('.png')) {
          mimeType = "image/png";
        } else if (attachment.toLowerCase().endsWith('.jpg') ||
            attachment.toLowerCase().endsWith('.jpeg')) {
          mimeType = "image/jpeg";
        } else if (attachment.toLowerCase().endsWith('.gif')) {
          mimeType = "image/gif";
        }

        return "data:$mimeType;base64,$base64";
      } else {
        return "error ${response.statusCode}";
      }
    } catch (e) {
      debugPrint("Error: $e");
    }

    return "error occur";
  }

  String formatDateToYMD(String? input) {
    if (input == null || input.trim().isEmpty) return '';

    try {
      DateTime date;
      String cleanInput = input.trim();

      if (RegExp(r'^\d{4}-\d{1,2}-\d{1,2}$').hasMatch(cleanInput)) {
        date = DateTime.parse(cleanInput);
      } else if (RegExp(r'^\d{1,2}/\d{1,2}/\d{4}$').hasMatch(cleanInput)) {
        date = DateFormat('dd/MM/yyyy').parse(cleanInput);
      } else if (RegExp(r'^\d{1,2}/\d{1,2}/\d{2}$').hasMatch(cleanInput)) {
        date = DateFormat('dd/MM/yy').parse(cleanInput);
      } else if (RegExp(
        r'^[A-Za-z]{3}\s\d{1,2},\s\d{4}$',
      ).hasMatch(cleanInput)) {
        date = DateFormat('MMM dd, yyyy').parse(cleanInput);
      } else if (RegExp(r'^[A-Za-z]+\s\d{1,2},\s\d{4}$').hasMatch(cleanInput)) {
        date = DateFormat('MMMM dd, yyyy').parse(cleanInput);
      } else {
        date = DateTime.parse(cleanInput);
      }
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      debugPrint("Date format error for input '$input': $e");
      return input;
    }
  }

  String formatDate({
    String? isoDate,
    bool isShowTime = false,
    String dateFormat = "MMM dd, yyyy",
    String timeFormat = "HH:mm:ss",
    bool showDateTimeInSingleLine = false,
    bool use24HourFormat = true,
  }) {
    if (isoDate == null || isoDate.isEmpty) return '';
    try {
      DateTime dateTime = DateTime.parse(isoDate).toLocal();

      String formattedDate = DateFormat(dateFormat).format(dateTime);

      if (isShowTime) {
        String formattedTime = use24HourFormat
            ? DateFormat(timeFormat).format(dateTime)
            : DateFormat('hh:mm a').format(dateTime);

        return '$formattedDate${showDateTimeInSingleLine ? ', ' : '\n'}$formattedTime';
      } else {
        return formattedDate;
      }
    } catch (e) {
      return '';
    }
  }

  static String formatNumber(dynamic value, {int fractionDigits = 1}) {
    if (value == null) return '0';

    double? numVal = double.tryParse(value.toString());
    if (numVal == null) return '0';

    if (numVal >= 1000000000000) {
      return '${(numVal / 1000000000000).toStringAsFixed(fractionDigits).replaceAll(RegExp(r'\.0+$'), '')}T';
    } else if (numVal >= 1000000000) {
      return '${(numVal / 1000000000).toStringAsFixed(fractionDigits).replaceAll(RegExp(r'\.0+$'), '')}B';
    } else if (numVal >= 1000000) {
      return '${(numVal / 1000000).toStringAsFixed(fractionDigits).replaceAll(RegExp(r'\.0+$'), '')}M';
    } else if (numVal >= 1000) {
      return '${(numVal / 1000).toStringAsFixed(fractionDigits).replaceAll(RegExp(r'\.0+$'), '')}K';
    } else {
      return numVal.toStringAsFixed(0);
    }
  }

  static bool isBase64(String str) {
    try {
      return base64.encode(base64.decode(str)) ==
          str.replaceAll('\n', '').replaceAll('\r', '');
    } catch (e) {
      return false;
    }
  }

  static String getImageUrl(String url) {
    if (url.contains(ApiEndpoints.storageBaseUrl)) {
      return url;
    } else if (url.startsWith("http")) {
      return url;
    }
    return "${ApiEndpoints.storageBaseUrl}/$url";
  }

  Future<void> launchURL(String? url) async {
    if (url == null || url.trim().isEmpty) return;

    try {
      final Uri uri = Uri.parse(url.trim());

      if (uri.scheme != 'http' && uri.scheme != 'https') {
        debugPrint('Invalid URL scheme: $url');
        return;
      }
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  String getFlagEmoji(String countryCode) {
    if (countryCode.isEmpty || countryCode.length != 2) return '🏳️';

    final String code = countryCode.toUpperCase();
    const int flagOffset = 0x1F1E6;
    const int asciiOffset = 0x41;

    final int firstChar = code.codeUnitAt(0) - asciiOffset + flagOffset;
    final int secondChar = code.codeUnitAt(1) - asciiOffset + flagOffset;

    return String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
  }

  static String formatDuration({required dynamic value}) {
    if (value == null || value.toString().isEmpty) return "00m00s";

    int totalSeconds = (num.tryParse(value.toString()) ?? 0).toInt();

    if (totalSeconds <= 0) return "00m00s";

    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    if (hours > 0) {
      return '${twoDigits(hours)}h${twoDigits(minutes)}m';
    } else if (minutes > 0) {
      return '${twoDigits(minutes)}m${twoDigits(seconds)}s';
    } else {
      return '${seconds}s';
    }
  }

  String generateRandomId([int length = 20]) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();

    return List.generate(
      length,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
  }
}
