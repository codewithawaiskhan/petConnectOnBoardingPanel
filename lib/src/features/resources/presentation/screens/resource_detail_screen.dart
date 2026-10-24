import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../app/config/api_endpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../../../resource_categories/presentation/widgets/category_svg_widget.dart';
import '../../domain/entities/resource_entity.dart';
import '../dialogs/add_edit_resource_dialog.dart';
import '../providers/resource_provider.dart';

class ResourceDetailScreen extends StatefulWidget {
  final String id;

  const ResourceDetailScreen({super.key, required this.id});

  @override
  State<ResourceDetailScreen> createState() => _ResourceDetailScreenState();
}

class _ResourceDetailScreenState extends State<ResourceDetailScreen>
    with AppColors, Constants {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ResourceProvider>().fetchResourceDetail(widget.id);
    });
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) return "—";
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      return DateFormat('MMM dd, yyyy • hh:mm a').format(dt);
    } catch (_) {
      return dateStr;
    }
  }

  Widget _buildCoverImage(String? rawImage) {
    if (rawImage == null || rawImage.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final trimmed = rawImage.trim();

    if (trimmed.startsWith('data:image')) {
      try {
        final commaIndex = trimmed.indexOf(',');
        final base64Part = commaIndex != -1
            ? trimmed.substring(commaIndex + 1)
            : trimmed;
        final bytes = base64Decode(base64Part.trim());
        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          constraints: const BoxConstraints(maxHeight: 340),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.memory(
            bytes,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const SizedBox.shrink(),
          ),
        );
      } catch (_) {
        return const SizedBox.shrink();
      }
    }

    final fullUrl =
        (trimmed.startsWith('http://') || trimmed.startsWith('https://'))
        ? trimmed
        : "${ApiEndpoints.storageBaseUrl}/$trimmed";

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      constraints: const BoxConstraints(maxHeight: 340),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        fullUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: textPrimaryColor),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/resources');
            }
          },
          tooltip: "Back to Resources",
        ),
        title: AppText(
          text: "Resource Details",
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textPrimaryColor,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: textSecondaryColor),
            tooltip: "Refresh Details",
            onPressed: () => context
                .read<ResourceProvider>()
                .fetchResourceDetail(widget.id, forceRefresh: true),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: borderColor, height: 1),
        ),
      ),
      body: Consumer<ResourceProvider>(
        builder: (context, provider, _) {
          if (provider.isDetailLoading && provider.selectedResource == null) {
            return Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          if (provider.errorMessage != null &&
              provider.selectedResource == null) {
            return Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: errorColor,
                    ),
                    const SizedBox(height: 14),
                    AppText(
                      text: "Failed to load resource details",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textPrimaryColor,
                    ),
                    const SizedBox(height: 8),
                    AppText(
                      text: provider.errorMessage!,
                      fontSize: 13,
                      color: textSecondaryColor,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: "Try Again",
                      width: 140,
                      height: 40,
                      fontSize: 13,
                      onTap: () => provider.fetchResourceDetail(
                        widget.id,
                        forceRefresh: true,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final resource = provider.selectedResource;
          if (resource == null) {
            return Center(
              child: AppText(
                text: "No resource data found",
                fontSize: 15,
                color: textSecondaryColor,
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(isDesktop ? 28.0 : 16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: Container(
                  padding: EdgeInsets.all(isDesktop ? 32 : 20),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderMeta(resource),
                      const SizedBox(height: 20),
                      _buildCoverImage(resource.featuredImage),
                      AppText(
                        text: resource.title,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: textPrimaryColor,
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1, thickness: 1),
                      const SizedBox(height: 20),
                      AppText(
                        text: "Content",
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: textSecondaryColor,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: borderColor),
                        ),
                        child: AppText(
                          text: resource.body,
                          fontSize: 14,
                          height: 1.6,
                          color: textPrimaryColor,
                          isHtml: true,
                          maxLines: 100,
                        ),
                      ),
                      const SizedBox(height: 28),
                      _buildDatesAndActions(context, resource),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderMeta(ResourceEntity resource) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // ID Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: borderColor),
          ),
          child: AppText(
            text:
                resource.longAutoIncrementId ??
                (resource.id.length > 8
                    ? resource.id.substring(0, 8).toUpperCase()
                    : resource.id.toUpperCase()),
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: textPrimaryColor,
          ),
        ),

        // Featured Badge
        if (resource.isFeatured)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: yellowColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_rounded, color: yellowColor, size: 14),
                const SizedBox(width: 4),
                AppText(
                  text: "Featured",
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: yellowColor,
                ),
              ],
            ),
          ),

        // Category Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CategorySvgWidget(
                icon: resource.postCategory?.icon,
                size: 18,
                iconSize: 12,
                radius: 4,
              ),
              const SizedBox(width: 6),
              AppText(
                text: resource.postCategory?.title ?? "General",
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ],
          ),
        ),

        // Read time badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 14,
                color: textSecondaryColor,
              ),
              const SizedBox(width: 5),
              AppText(
                text: "${resource.approxReadTimeInMinutes} min read",
                fontSize: 12,
                color: textSecondaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDatesAndActions(BuildContext context, ResourceEntity resource) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1, thickness: 1),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (resource.createdAt != null)
                  AppText(
                    text: "Created: ${_formatDate(resource.createdAt)}",
                    fontSize: 12,
                    color: textSecondaryColor,
                  ),
                if (resource.updatedAt != null) ...[
                  const SizedBox(height: 2),
                  AppText(
                    text: "Updated: ${_formatDate(resource.updatedAt)}",
                    fontSize: 12,
                    color: textSecondaryColor,
                  ),
                ],
              ],
            ),
            Row(
              children: [
                CustomButton(
                  text: "Back",
                  height: 38,
                  width: 90,
                  fontSize: 12,
                  isOutlined: true,
                  textColor: textPrimaryColor,
                  fillColor: whiteColor,
                  buttonBorder: Border.all(color: borderColor),
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/resources');
                    }
                  },
                ),
                const SizedBox(width: 10),
                CustomButton(
                  text: "Edit Resource",
                  height: 38,
                  fontSize: 12,
                  isIcon: true,
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                  onTap: () async {
                    final updated = await AddEditResourceDialog.show(
                      context,
                      resource: resource,
                    );
                    if (updated == true && context.mounted) {
                      context.read<ResourceProvider>().fetchResourceDetail(
                        resource.id,
                        forceRefresh: true,
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
