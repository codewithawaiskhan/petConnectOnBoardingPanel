import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/presentation/widgets/status_badge.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../../../../core/utils/responsive_extensions.dart';
import '../../../../core/utils/show_toast.dart';
import '../../../../shared/presentation/widgets/shimmers/data_table_shimmer.dart';
import '../../domain/entities/resource_category_entity.dart';
import '../dialogs/add_edit_resource_category_dialog.dart';
import '../providers/resource_category_provider.dart';
import '../widgets/category_svg_widget.dart';

class ResourceCategoriesListScreen extends StatefulWidget {
  const ResourceCategoriesListScreen({super.key});

  @override
  State<ResourceCategoriesListScreen> createState() =>
      _ResourceCategoriesListScreenState();
}

class _ResourceCategoriesListScreenState
    extends State<ResourceCategoriesListScreen>
    with AppColors, Constants {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ResourceCategoryProvider>();
      if (provider.categories.isEmpty) {
        provider.fetchCategories(isRefresh: true);
      }
    });
  }

  void _onSearchChanged() {
    context.read<ResourceCategoryProvider>().setSearchQuery(
      _searchController.text,
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _openAddEditDialog([ResourceCategoryEntity? category]) {
    AddEditResourceCategoryDialog.show(context, category: category);
  }

  void _confirmDelete(ResourceCategoryEntity category) {
    DialogUtils.showDynamicConfirmationDialog(
      context: context,
      title: "Delete Resource Category",
      message:
          "Are you sure you want to delete '${category.title}'? This action cannot be undone.",
      confirmText: "Delete",
      cancelText: "Cancel",
      onConfirm: () async {
        final provider = context.read<ResourceCategoryProvider>();
        final success = await provider.deleteCategory(category.id);
        if (mounted) {
          if (success) {
            showToast(context, "Category deleted successfully");
          } else {
            showToast(
              context,
              provider.errorMessage ?? "Failed to delete category",
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

  Widget _buildIconCell(String? iconUrl) {
    return CategorySvgWidget(icon: iconUrl, size: 38, iconSize: 22, radius: 8);
  }

  void _showCategoryDetailDialog(ResourceCategoryEntity item) {
    final displayId =
        item.longAutoIncrementId ??
        (item.autoIncrementId != null ? "PA${item.autoIncrementId}" : item.id);

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: Center(
            child: Container(
              width: 480,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 18,
                    ),
                    child: Row(
                      children: [
                        CategorySvgWidget(
                          icon: item.icon,
                          size: 38,
                          iconSize: 22,
                          radius: 10,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: item.title,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: textPrimaryColor,
                              ),
                              const SizedBox(height: 2),
                              AppText(
                                text: "Resource Category Details",
                                fontSize: 12,
                                color: textSecondaryColor,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: textSecondaryColor,
                            size: 22,
                          ),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1),

                  // Content Body
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(
                          "Category ID",
                          displayId,
                          isBadge: true,
                        ),
                        const SizedBox(height: 14),
                        _buildDetailRow(
                          "Status",
                          item.isDeleted ? "Deleted" : "Active",
                          isStatus: true,
                          isDeleted: item.isDeleted,
                        ),
                        const SizedBox(height: 14),
                        _buildDetailRow(
                          "Created At",
                          _formatDate(item.createdAt),
                        ),
                        const SizedBox(height: 14),
                        _buildDetailRow(
                          "Updated At",
                          _formatDate(item.updatedAt),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1),

                  // Actions Footer
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomButton(
                          text: "Close",
                          height: 38,
                          width: 80,
                          fontSize: 12,
                          isOutlined: true,
                          textColor: textPrimaryColor,
                          fillColor: whiteColor,
                          buttonBorder: Border.all(color: borderColor),
                          onTap: () => Navigator.of(ctx).pop(),
                        ),
                        const SizedBox(width: 10),
                        CustomButton(
                          text: "Edit Category",
                          height: 38,
                          fontSize: 12,
                          isIcon: true,
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: Colors.white,
                            size: 16,
                          ),
                          onTap: () {
                            Navigator.of(ctx).pop();
                            _openAddEditDialog(item);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isBadge = false,
    bool isStatus = false,
    bool isDeleted = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
          child: AppText(
            text: label,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textSecondaryColor,
          ),
        ),
        if (isStatus)
          StatusBadge(status: value, isDeleted: isDeleted, showDot: true)
        else if (isBadge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: borderColor),
            ),
            child: AppText(
              text: value,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: textPrimaryColor,
            ),
          )
        else
          AppText(
            text: value,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: textPrimaryColor,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Consumer<ResourceCategoryProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            color: primaryColor,
            onRefresh: () => provider.fetchCategories(isRefresh: true),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(provider, isDesktop),
                  const SizedBox(height: 20),
                  _buildSearchBar(provider, isDesktop),
                  const SizedBox(height: 20),
                  _buildContent(provider, isDesktop),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(ResourceCategoryProvider provider, bool isDesktop) {
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
      child: Icon(Icons.category_rounded, color: primaryColor, size: 26),
    );
  }

  Widget _buildHeaderTexts(ResourceCategoryProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppText(
              text: "Resource Categories",
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
              "Organize, create, and manage topics and classifications for portal resources.",
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: textSecondaryColor,
        ),
      ],
    );
  }

  Widget _buildHeaderActions(ResourceCategoryProvider provider) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: provider.isLoading
              ? null
              : () => provider.fetchCategories(isRefresh: true),
          icon: Icon(
            Icons.refresh_rounded,
            color: textSecondaryColor,
            size: 22,
          ),
          tooltip: "Refresh List",
        ),
        const SizedBox(width: 8),
        CustomButton(
          text: "Add Category",
          height: 42,
          fontSize: 13,
          isIcon: true,
          icon: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
          onTap: () => _openAddEditDialog(),
        ),
      ],
    );
  }

  Widget _buildSearchBar(ResourceCategoryProvider provider, bool isDesktop) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: _searchController,
              hintText: "Search categories by title or ID...",
              prefixIcon: Icon(
                Icons.search_rounded,
                color: textSecondaryColor,
                size: 20,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                        color: textSecondaryColor,
                        size: 18,
                      ),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ResourceCategoryProvider provider, bool isDesktop) {
    if (provider.isLoading && provider.categories.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final tableW = constraints.maxWidth > 800
              ? constraints.maxWidth
              : 800.0;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: tableW,
              child: DataTableShimmer(
                isDesktop: isDesktop,
                columnWidths: const {
                  0: FlexColumnWidth(1.1),
                  1: FlexColumnWidth(0.8),
                  2: FlexColumnWidth(2.4),
                  3: FlexColumnWidth(1.6),
                  4: FlexColumnWidth(1.6),
                  5: FlexColumnWidth(1.1),
                  6: FixedColumnWidth(110),
                },
                headers: const [
                  "ID",
                  "ICON",
                  "TITLE",
                  "CREATED AT",
                  "UPDATED AT",
                  "STATUS",
                  "ACTIONS",
                ],
              ),
            ),
          );
        },
      );
    }

    if (provider.errorMessage != null && provider.categories.isEmpty) {
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
              text: "Failed to load categories",
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
              onTap: () => provider.fetchCategories(isRefresh: true),
            ),
          ],
        ),
      );
    }

    final list = provider.categories;
    if (list.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 54, horizontal: 24),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.category_outlined,
                size: 40,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 18),
            AppText(
              text: provider.searchQuery.isNotEmpty
                  ? "No matching categories found"
                  : "No resource categories yet",
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: textPrimaryColor,
            ),
            const SizedBox(height: 6),
            AppText(
              text: provider.searchQuery.isNotEmpty
                  ? "Try adjusting your search criteria"
                  : "Get started by creating your first post category for resources",
              fontSize: 13,
              color: textSecondaryColor,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 22),
            if (provider.searchQuery.isEmpty)
              CustomButton(
                text: "Add First Category",
                width: 180,
                height: 42,
                fontSize: 13,
                isIcon: true,
                icon: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                onTap: () => _openAddEditDialog(),
              )
            else
              CustomButton(
                text: "Clear Search",
                width: 140,
                height: 40,
                fontSize: 13,
                isOutlined: true,
                onTap: () => _searchController.clear(),
              ),
          ],
        ),
      );
    }

    if (isDesktop) {
      return _buildDesktopTable(list);
    } else {
      return _buildMobileCards(list);
    }
  }

  Widget _buildDesktopTable(List<ResourceCategoryEntity> list) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final tableWidth = constraints.maxWidth > 850
                ? constraints.maxWidth
                : 850.0;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: tableWidth,
                child: Table(
                  columnWidths: const {
                    0: FixedColumnWidth(110), // ID
                    1: FixedColumnWidth(65), // Icon
                    2: FlexColumnWidth(1.8), // Title (reduced spacing)
                    3: FixedColumnWidth(140), // Created At (compact fixed width)
                    4: FixedColumnWidth(100), // Status
                    5: FixedColumnWidth(125), // Actions (View, Edit, Delete)
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    _buildTableHeaderRow(),
                    ...list.map((item) => _buildTableRow(item)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  TableRow _buildTableHeaderRow() {
    return TableRow(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      children: [
        _buildHeaderCell("ID"),
        _buildHeaderCell("ICON"),
        _buildHeaderCell("TITLE"),
        _buildHeaderCell("CREATED AT"),
        _buildHeaderCell("STATUS"),
        _buildHeaderCell("ACTIONS", align: TextAlign.right),
      ],
    );
  }

  Widget _buildHeaderCell(String label, {TextAlign align = TextAlign.left}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: AppText(
        text: label,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: textSecondaryColor,
        textAlign: align,
        letterSpacing: 0.5,
      ),
    );
  }

  TableRow _buildTableRow(ResourceCategoryEntity item) {
    final displayId =
        item.longAutoIncrementId ??
        (item.autoIncrementId != null
            ? "PA${item.autoIncrementId}"
            : item.id.substring(0, item.id.length > 8 ? 8 : item.id.length));

    return TableRow(
      decoration: BoxDecoration(
        color: whiteColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      children: [
        // ID
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: borderColor),
              ),
              child: AppText(
                text: displayId,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: textPrimaryColor,
              ),
            ),
          ),
        ),

        // Icon
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: _buildIconCell(item.icon),
          ),
        ),

        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: AppText(
            text: item.title,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
        ),

        // Created At
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: AppText(
            text: _formatDate(item.createdAt),
            fontSize: 12,
            color: textSecondaryColor,
          ),
        ),

        // Status
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Align(
            alignment: Alignment.centerLeft,
            child: StatusBadge(
              status: item.isDeleted ? "Deleted" : "Active",
              isDeleted: item.isDeleted,
              showDot: true,
            ),
          ),
        ),

        // Actions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                icon: Icon(
                  Icons.visibility_outlined,
                  size: 18,
                  color: textSecondaryColor,
                ),
                tooltip: "View Category",
                onPressed: () => _showCategoryDetailDialog(item),
              ),
              const SizedBox(width: 4),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                icon: Icon(Icons.edit_outlined, size: 18, color: primaryColor),
                tooltip: "Edit Category",
                onPressed: () => _openAddEditDialog(item),
              ),
              const SizedBox(width: 4),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                icon: Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: errorColor,
                ),
                tooltip: "Delete Category",
                onPressed: () => _confirmDelete(item),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileCards(List<ResourceCategoryEntity> list) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = list[index];
        final displayId =
            item.longAutoIncrementId ??
            (item.autoIncrementId != null
                ? "PA${item.autoIncrementId}"
                : item.id.substring(
                    0,
                    item.id.length > 8 ? 8 : item.id.length,
                  ));

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
                  _buildIconCell(item.icon),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: item.title,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: textPrimaryColor,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: borderColor),
                              ),
                              child: AppText(
                                text: displayId,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: textSecondaryColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            StatusBadge(
                              status: item.isDeleted ? "Deleted" : "Active",
                              isDeleted: item.isDeleted,
                              fontSize: 10,
                              showDot: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Divider(color: borderColor, height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: "Created: ${_formatDate(item.createdAt)}",
                    fontSize: 11,
                    color: textSecondaryColor,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        icon: Icon(
                          Icons.visibility_outlined,
                          size: 18,
                          color: textSecondaryColor,
                        ),
                        tooltip: "View Category",
                        onPressed: () => _showCategoryDetailDialog(item),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        icon: Icon(
                          Icons.edit_outlined,
                          size: 18,
                          color: primaryColor,
                        ),
                        tooltip: "Edit Category",
                        onPressed: () => _openAddEditDialog(item),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                          color: errorColor,
                        ),
                        tooltip: "Delete Category",
                        onPressed: () => _confirmDelete(item),
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
