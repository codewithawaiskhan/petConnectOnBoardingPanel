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
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../../../../core/utils/show_toast.dart';
import '../../../../shared/presentation/widgets/shimmers/data_table_shimmer.dart';
import '../../../resource_categories/presentation/providers/resource_category_provider.dart';
import '../../../resource_categories/presentation/widgets/category_svg_widget.dart';
import '../../domain/entities/resource_entity.dart';
import '../dialogs/add_edit_resource_dialog.dart';
import '../providers/resource_provider.dart';

class ResourcesListScreen extends StatefulWidget {
  const ResourcesListScreen({super.key});

  @override
  State<ResourcesListScreen> createState() => _ResourcesListScreenState();
}

class _ResourcesListScreenState extends State<ResourcesListScreen>
    with AppColors, Constants {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final resourceProvider = context.read<ResourceProvider>();
      if (resourceProvider.resources.isEmpty) {
        resourceProvider.fetchResources(isRefresh: true);
      }
      final catProvider = context.read<ResourceCategoryProvider>();
      if (catProvider.categories.isEmpty) {
        catProvider.fetchCategories(isRefresh: true);
      }
    });
  }

  void _onSearchChanged() {
    context.read<ResourceProvider>().setSearchQuery(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _openAddEditDialog([ResourceEntity? resource]) {
    AddEditResourceDialog.show(context, resource: resource);
  }

  void _confirmDelete(ResourceEntity resource) {
    DialogUtils.showDynamicConfirmationDialog(
      context: context,
      title: "Delete Resource",
      message:
          "Are you sure you want to delete '${resource.title}'? This action cannot be undone.",
      confirmText: "Delete",
      cancelText: "Cancel",
      onConfirm: () async {
        final provider = context.read<ResourceProvider>();
        final success = await provider.deleteResource(resource.id);
        if (mounted) {
          if (success) {
            showToast(context, "Resource deleted successfully");
          } else {
            showToast(
              context,
              provider.errorMessage ?? "Failed to delete resource",
              isError: true,
            );
          }
        }
      },
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) return "—";
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      return DateFormat('MMM dd, yyyy').format(dt);
    } catch (_) {
      return dateStr;
    }
  }

  Widget _buildCoverImage(String? rawImage, {double size = 44}) {
    if (rawImage == null || rawImage.trim().isEmpty) {
      return _buildCoverFallback(size: size);
    }

    final trimmed = rawImage.trim();

    if (trimmed.startsWith('data:image')) {
      try {
        final commaIndex = trimmed.indexOf(',');
        final base64Part =
            commaIndex != -1 ? trimmed.substring(commaIndex + 1) : trimmed;
        final bytes = base64Decode(base64Part.trim());
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            bytes,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                _buildCoverFallback(size: size),
          ),
        );
      } catch (_) {
        return _buildCoverFallback(size: size);
      }
    }

    final fullUrl =
        (trimmed.startsWith('http://') || trimmed.startsWith('https://'))
            ? trimmed
            : "${ApiEndpoints.storageBaseUrl}/$trimmed";

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        fullUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildCoverFallback(size: size),
      ),
    );
  }

  Widget _buildCoverFallback({double size = 44}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: primaryColor.withValues(alpha: 0.5),
          size: size * 0.48,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Consumer<ResourceProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            color: primaryColor,
            onRefresh: () => provider.fetchResources(isRefresh: true),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(provider, isDesktop),
                  const SizedBox(height: 20),
                  if (provider.resources.isNotEmpty ||
                      provider.searchQuery.isNotEmpty ||
                      provider.selectedCategoryFilter != null) ...[
                    _buildFilterBar(provider, isDesktop),
                    const SizedBox(height: 20),
                  ],
                  _buildContent(provider, isDesktop),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(ResourceProvider provider, bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 22 : 16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: isDesktop
          ? Row(
              children: [
                _buildHeaderIcon(),
                const SizedBox(width: 16),
                Expanded(child: _buildHeaderTexts(provider)),
                _buildHeaderActions(provider),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildHeaderIcon(),
                    const SizedBox(width: 12),
                    Expanded(child: _buildHeaderTexts(provider)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildHeaderActions(provider),
              ],
            ),
    );
  }

  Widget _buildHeaderIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.menu_book_rounded, color: primaryColor, size: 26),
    );
  }

  Widget _buildHeaderTexts(ResourceProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppText(
              text: "Resources Directory",
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: textPrimaryColor,
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: AppText(
                text: "${provider.totalCount} Total",
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        AppText(
          text:
              "Centralized repository of pet care articles, tips, and documentation.",
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: textSecondaryColor,
        ),
      ],
    );
  }

  Widget _buildHeaderActions(ResourceProvider provider) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: provider.isLoading
              ? null
              : () => provider.fetchResources(isRefresh: true),
          icon: Icon(
            Icons.refresh_rounded,
            color: textSecondaryColor,
            size: 22,
          ),
          tooltip: "Refresh List",
        ),
        const SizedBox(width: 8),
        CustomButton(
          text: "View Categories",
          height: 42,
          fontSize: 13,
          isOutlined: true,
          textColor: primaryColor,
          fillColor: whiteColor,
          buttonBorder: Border.all(color: primaryColor),
          onTap: () => context.go('/resource-categories'),
        ),
        const SizedBox(width: 10),
        CustomButton(
          text: "Add Resource",
          height: 42,
          fontSize: 13,
          isIcon: true,
          icon: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
          onTap: () => _openAddEditDialog(),
        ),
      ],
    );
  }

  Widget _buildFilterBar(ResourceProvider provider, bool isDesktop) {
    final catProvider = context.watch<ResourceCategoryProvider>();
    final categories = catProvider.categories;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: isDesktop
          ? Row(
              children: [
                Expanded(
                  flex: 3,
                  child: CustomTextField(
                    controller: _searchController,
                    hintText: "Search resources by title, content, or ID...",
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: textSecondaryColor,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                _buildCategoryFilterDropdown(provider, categories),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  controller: _searchController,
                  hintText: "Search resources by title, content, or ID...",
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: textSecondaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 12),
                _buildCategoryFilterDropdown(provider, categories),
              ],
            ),
    );
  }

  Widget _buildCategoryFilterDropdown(
    ResourceProvider provider,
    List dynamicCategories,
  ) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: provider.selectedCategoryFilter,
          hint: AppText(
            text: "All Categories",
            fontSize: 13,
            color: textSecondaryColor,
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: textSecondaryColor,
          ),
          onChanged: (val) => provider.setSelectedCategory(val),
          items: [
            DropdownMenuItem<String?>(
              value: null,
              child: AppText(
                text: "All Categories",
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: textPrimaryColor,
              ),
            ),
            ...dynamicCategories.map<DropdownMenuItem<String?>>((cat) {
              return DropdownMenuItem<String?>(
                value: cat.id,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CategorySvgWidget(
                      icon: cat.icon,
                      size: 18,
                      iconSize: 12,
                      radius: 4,
                    ),
                    const SizedBox(width: 8),
                    AppText(
                      text: cat.title,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: textPrimaryColor,
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ResourceProvider provider, bool isDesktop) {
    if (provider.isLoading && provider.resources.isEmpty) {
      return DataTableShimmer(isDesktop: isDesktop);
    }

    if (provider.errorMessage != null && provider.resources.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: errorColor),
            const SizedBox(height: 14),
            AppText(
              text: "Failed to load resources",
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textPrimaryColor,
            ),
            const SizedBox(height: 6),
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
              onTap: () => provider.fetchResources(isRefresh: true),
            ),
          ],
        ),
      );
    }

    final list = provider.resources;
    if (list.isEmpty) {
      return _buildEmptyState(provider);
    }

    return isDesktop
        ? _buildDesktopTable(list)
        : _buildMobileCards(list);
  }

  Widget _buildEmptyState(ResourceProvider provider) {
    final hasFilter =
        provider.searchQuery.isNotEmpty || provider.selectedCategoryFilter != null;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 24),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.menu_book_rounded,
              size: 46,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          AppText(
            text: hasFilter ? "No Matching Resources" : "Resources Hub",
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: AppText(
              text: hasFilter
                  ? "No resource articles match your search or filter criteria. Try clearing filters or creating a new post."
                  : "Articles, guides, FAQs, and multimedia resources library. Manage classifications in 'Resource Categories' or prepare upcoming educational materials.",
              fontSize: 13,
              color: textSecondaryColor,
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: "Manage Categories",
                height: 42,
                fontSize: 13,
                isOutlined: true,
                textColor: primaryColor,
                fillColor: whiteColor,
                buttonBorder: Border.all(color: primaryColor),
                onTap: () => context.go('/resource-categories'),
              ),
              const SizedBox(width: 14),
              CustomButton(
                text: "Add Resource",
                height: 42,
                fontSize: 13,
                isIcon: true,
                icon: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                onTap: () => _openAddEditDialog(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopTable(List<ResourceEntity> list) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  backgroundColor.withValues(alpha: 0.5),
                ),
                headingTextStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: textSecondaryColor,
                  letterSpacing: 0.5,
                ),
                dataRowMinHeight: 64,
                dataRowMaxHeight: 68,
                columnSpacing: 24,
                horizontalMargin: 20,
                columns: const [
                  DataColumn(label: Text("ID")),
                  DataColumn(label: Text("COVER")),
                  DataColumn(label: Text("TITLE")),
                  DataColumn(label: Text("CATEGORY")),
                  DataColumn(label: Text("CREATED AT")),
                  DataColumn(label: Text("ACTIONS")),
                ],
                rows: list.map((resource) {
                  return DataRow(
                    cells: [
                      // ID
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: borderColor),
                          ),
                          child: AppText(
                            text: resource.longAutoIncrementId ??
                                (resource.id.length > 8
                                    ? resource.id.substring(0, 8).toUpperCase()
                                    : resource.id.toUpperCase()),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: textPrimaryColor,
                          ),
                        ),
                      ),
                      // COVER
                      DataCell(
                        _buildCoverImage(resource.featuredImage, size: 44),
                      ),
                      // TITLE
                      DataCell(
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 340),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: AppText(
                                  text: resource.title,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimaryColor,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (resource.isFeatured) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 2.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: yellowColor.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: AppText(
                                    text: "Featured",
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: yellowColor,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      // CATEGORY
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CategorySvgWidget(
                              icon: resource.postCategory?.icon,
                              size: 24,
                              iconSize: 14,
                              radius: 6,
                            ),
                            const SizedBox(width: 8),
                            AppText(
                              text: resource.postCategory?.title ?? "General",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: textPrimaryColor,
                            ),
                          ],
                        ),
                      ),
                      // CREATED AT
                      DataCell(
                        AppText(
                          text: _formatDate(resource.createdAt),
                          fontSize: 12,
                          color: textSecondaryColor,
                        ),
                      ),
                      // ACTIONS
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () =>
                                  context.go('/resources/${resource.id}'),
                              icon: Icon(
                                Icons.visibility_outlined,
                                color: textSecondaryColor,
                                size: 18,
                              ),
                              tooltip: "View Details",
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              onPressed: () => _openAddEditDialog(resource),
                              icon: Icon(
                                Icons.edit_outlined,
                                color: primaryColor,
                                size: 18,
                              ),
                              tooltip: "Edit",
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              onPressed: () => _confirmDelete(resource),
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                color: errorColor,
                                size: 18,
                              ),
                              tooltip: "Delete",
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMobileCards(List<ResourceEntity> list) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final resource = list[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCoverImage(resource.featuredImage, size: 48),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: AppText(
                            text: resource.title,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (resource.isFeatured) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2.5,
                            ),
                            decoration: BoxDecoration(
                              color: yellowColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: AppText(
                              text: "Featured",
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: yellowColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, thickness: 1),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CategorySvgWidget(
                        icon: resource.postCategory?.icon,
                        size: 20,
                        iconSize: 12,
                        radius: 4,
                      ),
                      const SizedBox(width: 6),
                      AppText(
                        text: resource.postCategory?.title ?? "General",
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: textSecondaryColor,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () =>
                            context.go('/resources/${resource.id}'),
                        icon: Icon(
                          Icons.visibility_outlined,
                          color: textSecondaryColor,
                          size: 18,
                        ),
                        tooltip: "View Details",
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        onPressed: () => _openAddEditDialog(resource),
                        icon: Icon(
                          Icons.edit_outlined,
                          color: primaryColor,
                          size: 18,
                        ),
                        tooltip: "Edit",
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      IconButton(
                        onPressed: () => _confirmDelete(resource),
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          color: errorColor,
                          size: 18,
                        ),
                        tooltip: "Delete",
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
