import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../domain/entities/pet_gallery_entity.dart';
import '../providers/pet_gallery_provider.dart';
import 'pet_gallery_card.dart';

class PetGalleryTabView extends StatefulWidget {
  final String userId;

  const PetGalleryTabView({super.key, required this.userId});

  @override
  State<PetGalleryTabView> createState() => _PetGalleryTabViewState();
}

class _PetGalleryTabViewState extends State<PetGalleryTabView> with AppColors {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.userId.isNotEmpty) {
        context.read<PetGalleryProvider>().fetchPetGallery(widget.userId);
      }
    });
  }

  @override
  void didUpdateWidget(covariant PetGalleryTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId && widget.userId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<PetGalleryProvider>().fetchPetGallery(widget.userId);
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
                  "This pet parent profile does not have an active user ID linked to fetch pet gallery photos.",
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: textSecondaryColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Consumer<PetGalleryProvider>(
      builder: (context, provider, _) {
        final galleryItems = provider.filteredGalleryItems;
        final allGallery = provider.galleryItems;
        final petFilters = provider.availablePetFilters;

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
                    text: "Pet Gallery",
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
                      text: "${allGallery.length}",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Pet Filter Chips (if more than 1 pet available)
                  if (petFilters.length > 2) ...[
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: petFilters.map((filter) {
                            final isSelected = provider.selectedPetFilter
                                    .toLowerCase() ==
                                filter.toLowerCase();

                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: InkWell(
                                onTap: () =>
                                    provider.setSelectedPetFilter(filter),
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
                                    text: filter == 'All'
                                        ? 'All Photos'
                                        : filter,
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
                  ] else ...[
                    const Spacer(),
                  ],

                  // Refresh Button
                  IconButton(
                    icon: provider.isGalleryLoading
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
                    tooltip: "Refresh Gallery",
                    onPressed: provider.isGalleryLoading
                        ? null
                        : () => provider.fetchPetGallery(
                              widget.userId,
                              forceRefresh: true,
                            ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Content Area
            if (provider.isGalleryLoading && allGallery.isEmpty) ...[
              _buildShimmerGrid(context),
            ] else if (provider.errorMessage != null &&
                allGallery.isEmpty) ...[
              _buildErrorState(context, provider),
            ] else if (galleryItems.isEmpty) ...[
              _buildEmptyState(context, provider),
            ] else ...[
              _buildGalleryGrid(context, galleryItems),
            ],
          ],
        );
      },
    );
  }

  Widget _buildGalleryGrid(
      BuildContext context, List<PetGalleryEntity> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 4;
        if (constraints.maxWidth < 650) {
          crossAxisCount = 2;
        } else if (constraints.maxWidth < 1100) {
          crossAxisCount = 3;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 220,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return PetGalleryCard(item: item);
          },
        );
      },
    );
  }

  Widget _buildShimmerGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 4;
        if (constraints.maxWidth < 650) {
          crossAxisCount = 2;
        } else if (constraints.maxWidth < 1100) {
          crossAxisCount = 3;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 220,
          ),
          itemCount: 8,
          itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: backgroundColor,
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 12,
                        width: 90,
                        decoration: BoxDecoration(
                          color: borderColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 10,
                        width: 60,
                        decoration: BoxDecoration(
                          color: borderColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
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
      BuildContext context, PetGalleryProvider provider) {
    final hasFilter = provider.selectedPetFilter != 'All';

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
              Icons.photo_library_outlined,
              size: 40,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          AppText(
            text: hasFilter
                ? "No Photos Found For '${provider.selectedPetFilter}'"
                : "No Pet Photos Uploaded",
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: textPrimaryColor,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          AppText(
            text: hasFilter
                ? "Try selecting another pet or clear the active filter to see all gallery images."
                : "No gallery images or pet moments have been uploaded for this user yet.",
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: textSecondaryColor,
            textAlign: TextAlign.center,
          ),
          if (hasFilter) ...[
            const SizedBox(height: 16),
            CustomButton(
              text: "Reset Filter",
              onTap: () => provider.setSelectedPetFilter('All'),
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
      BuildContext context, PetGalleryProvider provider) {
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
            text: "Failed to Load Pet Gallery",
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
            onTap: () => provider.fetchPetGallery(
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
