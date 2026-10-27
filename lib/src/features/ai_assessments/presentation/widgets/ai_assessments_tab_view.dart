import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../domain/entities/ai_assessment_entity.dart';
import '../providers/ai_assessments_provider.dart';
import 'ai_assessment_card.dart';

class AiAssessmentsTabView extends StatefulWidget {
  final String userId;

  const AiAssessmentsTabView({super.key, required this.userId});

  @override
  State<AiAssessmentsTabView> createState() => _AiAssessmentsTabViewState();
}

class _AiAssessmentsTabViewState extends State<AiAssessmentsTabView>
    with AppColors {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.userId.isNotEmpty) {
        context
            .read<AiAssessmentsProvider>()
            .fetchAiAssessments(widget.userId);
      }
    });
  }

  @override
  void didUpdateWidget(covariant AiAssessmentsTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId && widget.userId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context
              .read<AiAssessmentsProvider>()
              .fetchAiAssessments(widget.userId);
        }
      });
    }
  }

  String _formatFilterName(String filter) {
    if (filter == 'All') return 'All Assessments';
    return filter
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty ? "${w[0].toUpperCase()}${w.substring(1)}" : "")
        .join(' ');
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
            Icon(Icons.person_off_outlined,
                size: 48, color: textSecondaryColor),
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
                  "This pet parent profile does not have an active user ID linked to fetch AI health assessment history.",
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: textSecondaryColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Consumer<AiAssessmentsProvider>(
      builder: (context, provider, _) {
        final assessments = provider.filteredAssessments;
        final allAssessments = provider.assessments;
        final filters = provider.availableFilters;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Bar: Title, Count, Filters & Refresh Button
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
                    text: "AI Health Assessments",
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
                      text: "${allAssessments.length}",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Filter Chips
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: filters.map((filter) {
                          final isSelected =
                              provider.selectedFilter.toLowerCase() ==
                                  filter.toLowerCase();

                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: InkWell(
                              onTap: () => provider.setSelectedFilter(filter),
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
                                  text: _formatFilterName(filter),
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? whiteColor
                                      : textSecondaryColor,
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
                    icon: provider.isAssessmentsLoading
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: primaryColor,
                            ),
                          )
                        : Icon(Icons.refresh_rounded,
                            color: textSecondaryColor),
                    tooltip: "Refresh Assessments",
                    onPressed: provider.isAssessmentsLoading
                        ? null
                        : () => provider.fetchAiAssessments(
                              widget.userId,
                              forceRefresh: true,
                            ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Content Area
            if (provider.isAssessmentsLoading && allAssessments.isEmpty) ...[
              _buildShimmerGrid(context),
            ] else if (provider.errorMessage != null &&
                allAssessments.isEmpty) ...[
              _buildErrorState(context, provider),
            ] else if (assessments.isEmpty) ...[
              _buildEmptyState(context, provider),
            ] else ...[
              _buildAssessmentsGrid(context, assessments),
            ],
          ],
        );
      },
    );
  }

  Widget _buildAssessmentsGrid(
      BuildContext context, List<AiAssessmentEntity> assessments) {
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
            mainAxisExtent: 175,
          ),
          itemCount: assessments.length,
          itemBuilder: (context, index) {
            final assessment = assessments[index];
            return AiAssessmentCard(assessment: assessment);
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
            mainAxisExtent: 175,
          ),
          itemCount: 6,
          itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 12,
                            width: 100,
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 9,
                            width: 60,
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
                Container(
                  height: 14,
                  width: 140,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  height: 12,
                  width: 100,
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
      BuildContext context, AiAssessmentsProvider provider) {
    final hasFilter = provider.selectedFilter != 'All';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_awesome_outlined,
              size: 40,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          AppText(
            text: hasFilter
                ? "No Assessments Found For '${_formatFilterName(provider.selectedFilter)}'"
                : "No AI Assessments Recorded",
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: textPrimaryColor,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          AppText(
            text: hasFilter
                ? "Try selecting another triage level or clear the active filter to see all records."
                : "No AI scan analyses or health evaluations have been recorded for this user yet.",
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: textSecondaryColor,
            textAlign: TextAlign.center,
          ),
          if (hasFilter) ...[
            const SizedBox(height: 16),
            CustomButton(
              text: "Reset Filter",
              onTap: () => provider.setSelectedFilter('All'),
              fillColor: primaryColor,
              textColor: whiteColor,
              height: 38,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState(
      BuildContext context, AiAssessmentsProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: errorColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.error_outline_rounded,
                size: 36, color: errorColor),
          ),
          const SizedBox(height: 12),
          AppText(
            text: "Failed to Load AI Assessments",
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 6),
          AppText(
            text: provider.errorMessage ?? "An unexpected error occurred.",
            fontSize: 12.5,
            fontWeight: FontWeight.w400,
            color: textSecondaryColor,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: "Retry",
            onTap: () => provider.fetchAiAssessments(
              widget.userId,
              forceRefresh: true,
            ),
            fillColor: primaryColor,
            textColor: whiteColor,
            height: 38,
          ),
        ],
      ),
    );
  }
}
