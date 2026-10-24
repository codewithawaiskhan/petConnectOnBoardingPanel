import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import '../../../../app/config/api_endpoints.dart';
import '../../../../app/di/injector.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/utils/mini_functions.dart';

class CategorySvgWidget extends StatefulWidget {
  final String? icon;
  final double size;
  final double iconSize;
  final double radius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? placeholderIconColor;
  final Color? iconColor;
  final bool showBorder;

  const CategorySvgWidget({
    super.key,
    required this.icon,
    this.size = 36,
    this.iconSize = 20,
    this.radius = 8,
    this.backgroundColor,
    this.borderColor,
    this.placeholderIconColor,
    this.iconColor,
    this.showBorder = true,
  });

  static final Map<String, String> _svgCache = {};

  @override
  State<CategorySvgWidget> createState() => _CategorySvgWidgetState();
}

class _CategorySvgWidgetState extends State<CategorySvgWidget> with AppColors {
  String? _svgString;
  String? _networkUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _resolveSvg();
  }

  @override
  void didUpdateWidget(covariant CategorySvgWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.icon != widget.icon) {
      _resolveSvg();
    }
  }

  void _resolveSvg() {
    final raw = widget.icon?.trim();
    if (raw == null || raw.isEmpty) {
      setState(() {
        _svgString = null;
        _networkUrl = null;
        _isLoading = false;
      });
      return;
    }

    // 1. Raw SVG XML string
    if (raw.startsWith('<svg') || raw.startsWith('<?xml')) {
      setState(() {
        _svgString = raw;
        _networkUrl = null;
        _isLoading = false;
      });
      return;
    }

    // 2. Data URI
    if (raw.startsWith('data:image')) {
      try {
        final commaIdx = raw.indexOf(',');
        if (commaIdx != -1) {
          final data = raw.substring(commaIdx + 1);
          if (raw.contains('base64')) {
            final decodedBytes = base64Decode(data);
            final decodedStr = utf8.decode(decodedBytes);
            setState(() {
              _svgString = decodedStr;
              _networkUrl = null;
              _isLoading = false;
            });
            return;
          } else {
            final decodedStr = Uri.decodeFull(data);
            setState(() {
              _svgString = decodedStr;
              _networkUrl = null;
              _isLoading = false;
            });
            return;
          }
        }
      } catch (e) {
        debugPrint('CategorySvgWidget DataURI decode error: $e');
      }
    }

    // 3. Base64 without prefix (PHN2Zy is base64 for <svg)
    if (raw.startsWith('PHN2Zy')) {
      try {
        final decodedBytes = base64Decode(raw);
        final decodedStr = utf8.decode(decodedBytes);
        setState(() {
          _svgString = decodedStr;
          _networkUrl = null;
          _isLoading = false;
        });
        return;
      } catch (_) {}
    }

    // 4. Resolve as Network URL
    final fullUrl = MiniFunctions.getImageUrl(raw);

    // Check memory cache
    if (CategorySvgWidget._svgCache.containsKey(fullUrl)) {
      setState(() {
        _svgString = CategorySvgWidget._svgCache[fullUrl];
        _networkUrl = fullUrl;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _networkUrl = fullUrl;
    });

    // Fetch from remote
    _fetchRemoteSvg(raw, fullUrl);
  }

  Future<void> _fetchRemoteSvg(String rawPath, String fullUrl) async {
    setState(() {
      _isLoading = true;
    });

    final cleanPath = rawPath.startsWith('/') ? rawPath.substring(1) : rawPath;
    final candidates = <String>[
      fullUrl,
      if (!fullUrl.contains(cleanPath))
        "${ApiEndpoints.storageBaseUrl}/$cleanPath",
      "${ApiEndpoints.baseUrl}/$cleanPath",
    ];

    for (final url in candidates) {
      try {
        final isS3 = url.contains('amazonaws.com');
        final token = sl<ApiServices>().token;

        // Never send Bearer token to AWS S3 (causes 400 Bad Request)
        final headers = <String, String>{
          'Accept': 'image/svg+xml, text/plain, */*',
          if (!isS3 && token != null && token.isNotEmpty && token != 'null')
            'Authorization':
                'Bearer ${token.replaceFirst('Bearer ', '').trim()}',
        };

        final response = await http
            .get(Uri.parse(url), headers: headers)
            .timeout(const Duration(seconds: 8));

        if (response.statusCode == 200 &&
            response.body.isNotEmpty &&
            (response.body.contains('<svg') ||
                response.body.contains('<?xml'))) {
          CategorySvgWidget._svgCache[fullUrl] = response.body;
          if (mounted) {
            setState(() {
              _svgString = response.body;
              _isLoading = false;
            });
          }
          return;
        }
      } catch (e) {
        debugPrint('CategorySvgWidget fetch error ($url): $e');
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBg =
        widget.backgroundColor ?? primaryColor.withValues(alpha: 0.08);
    final effectiveBorder = widget.borderColor ??
        (widget.showBorder ? borderColor : Colors.transparent);
    final effectiveIconColor =
        widget.iconColor ?? widget.placeholderIconColor ?? primaryColor;

    Widget content;
    if (_svgString != null && _svgString!.isNotEmpty) {
      content = SvgPicture.string(
        _svgString!,
        width: widget.iconSize,
        height: widget.iconSize,
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(effectiveIconColor, BlendMode.srcIn),
        placeholderBuilder: (_) => Icon(
          Icons.category_rounded,
          size: widget.iconSize,
          color: effectiveIconColor,
        ),
      );
    } else if (_networkUrl != null && _networkUrl!.isNotEmpty) {
      content = SvgPicture.network(
        _networkUrl!,
        width: widget.iconSize,
        height: widget.iconSize,
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(effectiveIconColor, BlendMode.srcIn),
        placeholderBuilder: (_) => SizedBox(
          width: widget.iconSize * 0.7,
          height: widget.iconSize * 0.7,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: effectiveIconColor,
          ),
        ),
      );
    } else if (_isLoading) {
      content = SizedBox(
        width: widget.iconSize * 0.7,
        height: widget.iconSize * 0.7,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: effectiveIconColor,
        ),
      );
    } else {
      content = Icon(
        Icons.category_rounded,
        size: widget.iconSize,
        color: effectiveIconColor,
      );
    }

    return Container(
      width: widget.size,
      height: widget.size,
      padding: EdgeInsets.all(widget.size * 0.18),
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: BorderRadius.circular(widget.radius),
        border: widget.showBorder ? Border.all(color: effectiveBorder) : null,
      ),
      child: Center(child: content),
    );
  }
}
