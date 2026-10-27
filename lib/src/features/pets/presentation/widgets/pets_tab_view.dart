import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../domain/entities/pet_entity.dart';
import '../providers/pets_provider.dart';
import 'pet_card.dart';

class PetsTabView extends StatefulWidget {
  final String parentId;

  const PetsTabView({super.key, required this.parentId});

  @override
  State<PetsTabView> createState() => _PetsTabViewState();
}

class _PetsTabViewState extends State<PetsTabView> with AppColors {
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PetsProvider>().fetchPets(widget.parentId);
      }
    });
  }

  @override
  void didUpdateWidget(covariant PetsTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.parentId != widget.parentId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<PetsProvider>().fetchPets(widget.parentId);
        }
      });
    }
  }

  List<PetEntity> _filterPets(List<PetEntity> pets) {
    if (_selectedCategory == 'All') return pets;
    return pets.where((p) {
      final cat = p.categoryTitle?.trim().toLowerCase();
      return cat == _selectedCategory.toLowerCase();
    }).toList();
  }

  List<String> _getCategories(List<PetEntity> pets) {
    final categories = <String>{'All'};
    for (final p in pets) {
      if (p.categoryTitle != null && p.categoryTitle!.trim().isNotEmpty) {
        categories.add(p.categoryTitle!.trim());
      }
    }
    return categories.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PetsProvider>(
      builder: (context, provider, _) {
        if (provider.isPetsLoading && provider.pets.isEmpty) {
          return _buildShimmerGrid();
        }

        if (provider.errorMessage != null && provider.pets.isEmpty) {
          return _buildErrorState(provider);
        }

        if (provider.pets.isEmpty) {
          return _buildEmptyState(provider);
        }

        final categories = _getCategories(provider.pets);
        final filteredPets = _filterPets(provider.pets);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section Bar (Count, Filter chips & Refresh)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    AppText(
                      text: "Registered Pets",
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: textPrimaryColor,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: AppText(
                        text: "${provider.pets.length}",
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.refresh_rounded,
                    color: textSecondaryColor,
                    size: 20,
                  ),
                  tooltip: "Refresh Pets",
                  onPressed: () => provider.fetchPets(
                    widget.parentId,
                    forceRefresh: true,
                  ),
                ),
              ],
            ),

            // Category filter chips if more than 1 category
            if (categories.length > 2) ...[
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () => setState(() => _selectedCategory = cat),
                        borderRadius: BorderRadius.circular(20),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? primaryColor
                                : whiteColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? primaryColor : borderColor,
                            ),
                          ),
                          child: AppText(
                            text: cat,
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected ? whiteColor : textSecondaryColor,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Responsive Pets Grid (Clean aspect ratio, no squishing, no image cut-off)
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final int crossAxisCount;
                if (width >= 1150) {
                  crossAxisCount = 3;
                } else if (width >= 720) {
                  crossAxisCount = 2;
                } else {
                  crossAxisCount = 1;
                }

                if (filteredPets.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                    ),
                    child: Center(
                      child: AppText(
                        text: "No pets match the selected category.",
                        fontSize: 13,
                        color: textSecondaryColor,
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredPets.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    mainAxisExtent: 485,
                  ),
                  itemBuilder: (context, index) {
                    final pet = filteredPets[index];
                    return PetCard(pet: pet);
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(PetsProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.pets_rounded,
                size: 44,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            AppText(
              text: "No Pets Found",
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: textPrimaryColor,
            ),
            const SizedBox(height: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: AppText(
                text:
                    "This pet parent currently has no registered pets associated with their account.",
                fontSize: 13,
                color: textSecondaryColor,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Refresh List",
              width: 140,
              height: 38,
              fontSize: 13,
              isOutlined: true,
              textColor: primaryColor,
              buttonBorder: Border.all(color: primaryColor),
              onTap: () => provider.fetchPets(
                widget.parentId,
                forceRefresh: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(PetsProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 24),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: errorColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 40,
                color: errorColor,
              ),
            ),
            const SizedBox(height: 16),
            AppText(
              text: "Failed to Load Pets",
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textPrimaryColor,
            ),
            const SizedBox(height: 6),
            AppText(
              text: provider.errorMessage ?? "An unexpected error occurred.",
              fontSize: 13,
              color: textSecondaryColor,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            CustomButton(
              text: "Try Again",
              width: 130,
              height: 38,
              fontSize: 13,
              onTap: () => provider.fetchPets(
                widget.parentId,
                forceRefresh: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final int crossAxisCount;
        if (width >= 1150) {
          crossAxisCount = 3;
        } else if (width >= 720) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 1;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            mainAxisExtent: 485,
          ),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(17),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 18,
                          width: 140,
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 14,
                          width: 90,
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 70,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 36,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
