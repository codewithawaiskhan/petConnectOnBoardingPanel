import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../domain/entities/medical_record_entity.dart';
import '../providers/medical_records_provider.dart';
import 'medical_record_card.dart';

class MedicalRecordsTabView extends StatefulWidget {
  final String userId;

  const MedicalRecordsTabView({super.key, required this.userId});

  @override
  State<MedicalRecordsTabView> createState() => _MedicalRecordsTabViewState();
}

class _MedicalRecordsTabViewState extends State<MedicalRecordsTabView>
    with AppColors {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.userId.isNotEmpty) {
        context
            .read<MedicalRecordsProvider>()
            .fetchMedicalRecords(widget.userId);
      }
    });
  }

  @override
  void didUpdateWidget(covariant MedicalRecordsTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId && widget.userId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context
              .read<MedicalRecordsProvider>()
              .fetchMedicalRecords(widget.userId);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userId.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            Icon(Icons.person_off_outlined, size: 48, color: textSecondaryColor),
            const SizedBox(height: 12),
            AppText(
              text: "No User Account Linked",
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textPrimaryColor,
            ),
            const SizedBox(height: 6),
            AppText(
              text:
                  "This pet parent profile does not have an active user ID linked to fetch clinical records.",
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: textSecondaryColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Consumer<MedicalRecordsProvider>(
      builder: (context, provider, _) {
        final records = provider.filteredRecords;
        final allRecords = provider.records;
        final categories = provider.availableCategories;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Bar: Title, Count, Categories & Refresh Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  AppText(
                    text: "Medical Records",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textPrimaryColor,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AppText(
                      text: "${allRecords.length}",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Filter Categories
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: categories.map((cat) {
                          final isSelected = provider.selectedCategory.toLowerCase() ==
                              cat.toLowerCase();
                          final displayName = cat == 'All'
                              ? 'All Records'
                              : "${cat[0].toUpperCase()}${cat.substring(1).toLowerCase()}";

                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: InkWell(
                              onTap: () => provider.setSelectedCategory(cat),
                              borderRadius: BorderRadius.circular(20),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? primaryColor
                                      : backgroundColor,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? primaryColor
                                        : borderColor,
                                  ),
                                ),
                                child: AppText(
                                  text: displayName,
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color:
                                      isSelected ? whiteColor : textSecondaryColor,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // Refresh Button
                  IconButton(
                    icon: provider.isRecordsLoading
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: primaryColor,
                            ),
                          )
                        : Icon(Icons.refresh_rounded, color: textSecondaryColor),
                    tooltip: "Refresh Records",
                    onPressed: provider.isRecordsLoading
                        ? null
                        : () => provider.fetchMedicalRecords(
                              widget.userId,
                              forceRefresh: true,
                            ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Content Area
            if (provider.isRecordsLoading && allRecords.isEmpty) ...[
              _buildShimmerGrid(context),
            ] else if (provider.errorMessage != null && allRecords.isEmpty) ...[
              _buildErrorState(context, provider),
            ] else if (records.isEmpty) ...[
              _buildEmptyState(context, provider),
            ] else ...[
              _buildRecordsGrid(context, records),
            ],
          ],
        );
      },
    );
  }

  Widget _buildRecordsGrid(
      BuildContext context, List<MedicalRecordEntity> records) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 3;
        if (constraints.maxWidth < 650) {
          crossAxisCount = 1;
        } else if (constraints.maxWidth < 1100) {
          crossAxisCount = 2;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 148,
          ),
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index];
            return MedicalRecordCard(record: record);
          },
        );
      },
    );
  }

  Widget _buildShimmerGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 3;
        if (constraints.maxWidth < 650) {
          crossAxisCount = 1;
        } else if (constraints.maxWidth < 1100) {
          crossAxisCount = 2;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 148,
          ),
          itemCount: 6,
          itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 14,
                            width: 120,
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 10,
                            width: 80,
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const Spacer(),
                Container(
                  height: 12,
                  width: 140,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(
      BuildContext context, MedicalRecordsProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.medical_services_outlined,
              size: 40,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          AppText(
            text: provider.selectedCategory == 'All'
                ? "No Medical Records Found"
                : "No ${provider.selectedCategory} Records",
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 8),
          AppText(
            text: provider.selectedCategory == 'All'
                ? "There are no medical or clinical records logged for this user's pets yet."
                : "No records found under the '${provider.selectedCategory}' category.",
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: textSecondaryColor,
            textAlign: TextAlign.center,
          ),
          if (provider.selectedCategory != 'All') ...[
            const SizedBox(height: 16),
            CustomButton(
              text: "Reset Category Filter",
              fillColor: primaryColor,
              textColor: whiteColor,
              height: 42,
              onTap: () => provider.setSelectedCategory('All'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState(
      BuildContext context, MedicalRecordsProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline_rounded, size: 48, color: errorColor),
          const SizedBox(height: 12),
          AppText(
            text: "Failed to Load Medical Records",
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 6),
          AppText(
            text: provider.errorMessage ?? "An unexpected error occurred.",
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: textSecondaryColor,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: "Retry",
            fillColor: primaryColor,
            textColor: whiteColor,
            height: 42,
            onTap: () => provider.fetchMedicalRecords(
              widget.userId,
              forceRefresh: true,
            ),
          ),
        ],
      ),
    );
  }
}
