import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../app/config/api_endpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../domain/entities/pet_entity.dart';
import '../dialogs/pet_details_dialog.dart';

class PetCard extends StatefulWidget {
  final PetEntity pet;

  const PetCard({super.key, required this.pet});

  @override
  State<PetCard> createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> with AppColors {
  bool _isHovered = false;

  String _calculateAge(String? dobStr) {
    if (dobStr == null || dobStr.trim().isEmpty) return "";
    try {
      final dob = DateTime.parse(dobStr).toLocal();
      final now = DateTime.now();
      int years = now.year - dob.year;
      int months = now.month - dob.month;
      if (now.day < dob.day) {
        months--;
      }
      if (months < 0) {
        years--;
        months += 12;
      }
      if (years > 0 && months > 0) {
        return "$years yr $months mo";
      } else if (years > 0) {
        return "$years yr${years > 1 ? 's' : ''}";
      } else if (months > 0) {
        return "$months mo${months > 1 ? 's' : ''}";
      } else {
        final days = now.difference(dob).inDays;
        return "$days day${days != 1 ? 's' : ''}";
      }
    } catch (_) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final pet = widget.pet;
    final image = pet.image;
    final hasImage = image != null && image.trim().isNotEmpty;
    final imageUrl = hasImage
        ? (image.startsWith('http')
            ? image
            : "${ApiEndpoints.storageBaseUrl}/$image")
        : null;

    final ageString = _calculateAge(pet.dob);
    final gender = pet.gender?.trim();
    final isMale = gender?.toLowerCase() == 'male';
    final isFemale = gender?.toLowerCase() == 'female';
    final displayId = pet.longAutoIncrementId ??
        (pet.autoIncrementId != null ? "PE#${pet.autoIncrementId}" : "");

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered ? primaryColor.withValues(alpha: 0.5) : borderColor,
            width: _isHovered ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? primaryColor.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.03),
              blurRadius: _isHovered ? 16 : 8,
              offset: Offset(0, _isHovered ? 6 : 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PET PHOTO CONTAINER (Seamless ambient backdrop, ZERO grey boxes, uncropped)
            SizedBox(
              height: 195,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Clean white base
                  Container(color: whiteColor),

                  // Ambient soft blurred backdrop if image exists
                  if (imageUrl != null) ...[
                    ClipRect(
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Transform.scale(
                          scale: 1.35,
                          child: Opacity(
                            opacity: 0.55,
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const SizedBox(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Light wash overlay transitioning smoothly into card body
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.25),
                            Colors.transparent,
                            whiteColor.withValues(alpha: 0.7),
                            whiteColor,
                          ],
                          stops: const [0.0, 0.4, 0.85, 1.0],
                        ),
                      ),
                    ),
                  ],

                  // Clear foreground uncropped pet photo
                  if (imageUrl != null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildPlaceholder(),
                        ),
                      ),
                    )
                  else
                    _buildPlaceholder(),

                  // Top Left Badges: Category & ID Pill
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (pet.categoryTitle != null &&
                            pet.categoryTitle!.trim().isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: whiteColor.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.pets_rounded,
                                  size: 11,
                                  color: primaryColor,
                                ),
                                const SizedBox(width: 4),
                                AppText(
                                  text: pet.categoryTitle!,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: textPrimaryColor,
                                ),
                              ],
                            ),
                          ),
                        if (displayId.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: AppText(
                              text: displayId,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: whiteColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Top Right Badge: Gender
                  if (gender != null && gender.isNotEmpty)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isMale
                              ? primaryColor.withValues(alpha: 0.92)
                              : (isFemale
                                  ? tertiaryColor.withValues(alpha: 0.92)
                                  : textSecondaryColor.withValues(alpha: 0.92)),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isMale
                                  ? Icons.male_rounded
                                  : (isFemale
                                      ? Icons.female_rounded
                                      : Icons.pets_rounded),
                              size: 12,
                              color: whiteColor,
                            ),
                            const SizedBox(width: 3),
                            AppText(
                              text: gender,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: whiteColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // PET DETAILS BODY (Expanded with zero possibility of overflow)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Age Tag
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: AppText(
                            text: pet.name,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: textPrimaryColor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (ageString.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2.5,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: AppText(
                              text: ageString,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),

                    // Breed subtitle
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 6,
                          color: primaryColor,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: AppText(
                            text: pet.breed?.trim().isNotEmpty == true
                                ? pet.breed!
                                : "Breed Unspecified",
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: textSecondaryColor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // 4-STAT GRID: Pure White with Crisp Border (NO grey)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildMiniStat(
                                  icon: Icons.scale_rounded,
                                  label: "Weight",
                                  value: pet.weight != null
                                      ? "${pet.weight} ${pet.weightUnit ?? 'lb'}"
                                      : "—",
                                  color: primaryColor,
                                ),
                              ),
                              Container(
                                height: 22,
                                width: 1,
                                color: borderColor,
                              ),
                              Expanded(
                                child: _buildMiniStat(
                                  icon: Icons.height_rounded,
                                  label: "Height",
                                  value: pet.height != null
                                      ? "${pet.height} ${pet.heightUnit ?? 'cm'}"
                                      : "—",
                                  color: tertiaryColor,
                                ),
                              ),
                            ],
                          ),
                          Divider(height: 12, thickness: 1, color: borderColor),
                          Row(
                            children: [
                              Expanded(
                                child: _buildMiniStat(
                                  icon: Icons.bloodtype_outlined,
                                  label: "Blood Group",
                                  value: pet.bloodGroup?.isNotEmpty == true
                                      ? "Type ${pet.bloodGroup}"
                                      : "—",
                                  color: errorColor,
                                ),
                              ),
                              Container(
                                height: 22,
                                width: 1,
                                color: borderColor,
                              ),
                              Expanded(
                                child: _buildMiniStat(
                                  icon: Icons.verified_outlined,
                                  label: "Registry",
                                  value: pet.registry?.isNotEmpty == true
                                      ? pet.registry!
                                      : (pet.breeder?.isNotEmpty == true
                                          ? pet.breeder!
                                          : "—"),
                                  color: textSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Description Snippet (Clean inline text)
                    if (pet.description != null &&
                        pet.description!.trim().isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.format_quote_rounded,
                            size: 13,
                            color: primaryColor.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: AppText(
                              text: pet.description!.trim(),
                              fontSize: 11.5,
                              color: textSecondaryColor,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],

                    // Spacer absorbs remaining space to pin button cleanly
                    const Spacer(),

                    // "View Full Profile" Action Button
                    CustomButton(
                      text: "View Full Profile",
                      isIcon: true,
                      icon: Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: whiteColor,
                      ),
                      fillColor: primaryColor,
                      textColor: whiteColor,
                      height: 38,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      radius: 10,
                      onTap: () => PetDetailsDialog.show(context, pet),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 13, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  text: label,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: textSecondaryColor,
                ),
                AppText(
                  text: value,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: textPrimaryColor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.pets_rounded,
              size: 32,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 6),
          AppText(
            text: "No Photo Available",
            fontSize: 11,
            color: textSecondaryColor,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
