import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_countries.dart';
import '../../../../core/presentation/widgets/app_country_picker_field.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../domain/entities/top_countries_entity.dart';

class TopStatesStatsCard extends StatefulWidget {
  final TopCountriesStatsEntity topStates;
  final bool isLoading;
  final String selectedCountryCode;
  final ValueChanged<String> onCountryChanged;

  const TopStatesStatsCard({
    super.key,
    required this.topStates,
    this.isLoading = false,
    required this.selectedCountryCode,
    required this.onCountryChanged,
  });

  @override
  State<TopStatesStatsCard> createState() => _TopStatesStatsCardState();
}

class _TopStatesStatsCardState extends State<TopStatesStatsCard>
    with AppColors {
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    "Pet Parents",
    "Vets",
    "Diagnostic Labs",
    "Service Providers",
  ];

  final List<IconData> _categoryIcons = [
    Icons.pets_rounded,
    Icons.medical_services_rounded,
    Icons.biotech_rounded,
    Icons.storefront_rounded,
  ];

  List<CountryStatItemEntity> get _activeList {
    switch (_selectedCategoryIndex) {
      case 0:
        return widget.topStates.petParents;
      case 1:
        return widget.topStates.doctors;
      case 2:
        return widget.topStates.labs;
      case 3:
        return widget.topStates.serviceProviders;
      default:
        return widget.topStates.petParents;
    }
  }

  int get _activeTotalUsers {
    return _activeList.fold<int>(0, (sum, item) => sum + item.count);
  }

  @override
  Widget build(BuildContext context) {
    final activeData = _activeList;
    final totalUsers = _activeTotalUsers;
    final int maxCount = activeData.isNotEmpty ? activeData.first.count : 1;
    final currentCountryName = AppCountries.getCountryName(
      widget.selectedCountryCode,
    );
    final currentCountryFlag = AppCountries.getFlag(widget.selectedCountryCode);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Title, Country Dropdown & Total Badge
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 700;

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.map_rounded,
                            size: 20,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: "State / Province Distribution",
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: textPrimaryColor,
                              ),
                              const SizedBox(height: 2),
                              AppText(
                                text:
                                    "Top regions for $currentCountryName by user role",
                                fontSize: 12,
                                color: textSecondaryColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _buildCountryDropdown(),
                        _buildTotalBadge(totalUsers),
                      ],
                    ),
                  ],
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.map_rounded,
                          size: 20,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: "State / Province Distribution",
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                          ),
                          const SizedBox(height: 2),
                          AppText(
                            text:
                                "Top regions for $currentCountryName by user role",
                            fontSize: 12,
                            color: textSecondaryColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildCountryDropdown(),
                      const SizedBox(width: 12),
                      _buildTotalBadge(totalUsers),
                    ],
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 18),

          // Role Switcher Tabs (Strictly WITHOUT count badges)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(_categories.length, (index) {
                final isSelected = _selectedCategoryIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? primaryColor
                            : primaryColor.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? primaryColor : borderColor,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _categoryIcons[index],
                            size: 15,
                            color: isSelected ? whiteColor : textSecondaryColor,
                          ),
                          const SizedBox(width: 7),
                          AppText(
                            text: _categories[index],
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: isSelected ? whiteColor : textPrimaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 20),

          // State List Items or Empty State
          if (widget.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 36),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (activeData.isEmpty)
            _buildEmptyState(currentCountryName, currentCountryFlag)
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activeData.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = activeData[index];
                final stateName = item.displayName;
                final double ratio = maxCount > 0 ? item.count / maxCount : 0.0;
                final double totalRatio = totalUsers > 0
                    ? (item.count / totalUsers) * 100
                    : 0.0;

                return _buildStateItemRow(
                  rank: index + 1,
                  stateName: stateName,
                  countryCode: item.countryCode ?? widget.selectedCountryCode,
                  count: item.count,
                  ratio: ratio,
                  percentage: totalRatio,
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCountryDropdown() {
    return AppCountryPickerField(
      isFilterMode: true,
      selectedCountryCode: widget.selectedCountryCode,
      width: 220,
      height: 40,
      radius: 8,
      onCountrySelected: (country) {
        if (country.code != widget.selectedCountryCode) {
          widget.onCountryChanged(country.code);
        }
      },
    );
  }

  Widget _buildTotalBadge(int total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primaryColor.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            text: "Total in Role: ",
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: textSecondaryColor,
          ),
          AppText(
            text: "$total Users",
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildStateItemRow({
    required int rank,
    required String stateName,
    required String countryCode,
    required int count,
    required double ratio,
    required double percentage,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: rank <= 3
                  ? primaryColor.withValues(alpha: 0.12)
                  : whiteColor,
              shape: BoxShape.circle,
            ),
            child: AppText(
              text: "#$rank",
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: rank <= 3 ? primaryColor : textSecondaryColor,
            ),
          ),
          const SizedBox(width: 10),

          // Location Pin Icon
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.location_on_rounded,
              size: 14,
              color: primaryColor,
            ),
          ),
          const SizedBox(width: 10),

          // State Name + Country Code Badge
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Flexible(
                  child: AppText(
                    text: stateName.isNotEmpty ? stateName : "Unknown Region",
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textPrimaryColor,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (countryCode.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: AppText(
                      text: countryCode.toUpperCase(),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Relative Bar
          Expanded(
            flex: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                height: 8,
                color: primaryColor.withValues(alpha: 0.08),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: ratio.clamp(0.02, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Count & Percentage
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                text: "$count",
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: textPrimaryColor,
              ),
              const SizedBox(width: 4),
              AppText(
                text: "(${percentage.toStringAsFixed(1)}%)",
                fontSize: 11,
                color: textSecondaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String countryName, String flag) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Icon(
            Icons.location_off_rounded,
            size: 38,
            color: textSecondaryColor.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 10),
          AppText(
            text: "No State Data for $countryName $flag",
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          const SizedBox(height: 4),
          AppText(
            text:
                "No registered ${_categories[_selectedCategoryIndex]} with recorded state/province found in $countryName.",
            fontSize: 12,
            color: textSecondaryColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
