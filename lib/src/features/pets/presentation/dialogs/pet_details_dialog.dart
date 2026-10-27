import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/config/api_endpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../domain/entities/pet_entity.dart';

class PetDetailsDialog extends StatelessWidget with AppColors {
  final PetEntity pet;

  const PetDetailsDialog({super.key, required this.pet});

  static Future<void> show(BuildContext context, PetEntity pet) {
    return showDialog<void>(
      context: context,
      builder: (_) => PetDetailsDialog(pet: pet),
    );
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

  String _formatDob(String? dobStr) {
    if (dobStr == null || dobStr.trim().isEmpty) return "—";
    try {
      final dt = DateTime.parse(dobStr).toLocal();
      return DateFormat('MMMM dd, yyyy').format(dt);
    } catch (_) {
      return dobStr;
    }
  }

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
        return "$years yr $months mo old";
      } else if (years > 0) {
        return "$years yr${years > 1 ? 's' : ''} old";
      } else if (months > 0) {
        return "$months mo${months > 1 ? 's' : ''} old";
      } else {
        final days = now.difference(dob).inDays;
        return "$days day${days != 1 ? 's' : ''} old";
      }
    } catch (_) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = pet.image;
    final hasImage = image != null && image.trim().isNotEmpty;
    final imageUrl = hasImage
        ? (image.startsWith('http')
            ? image
            : "${ApiEndpoints.storageBaseUrl}/$image")
        : null;

    final ageString = _calculateAge(pet.dob);
    final displayId = pet.longAutoIncrementId ??
        (pet.autoIncrementId != null ? "PE#${pet.autoIncrementId}" : "");

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680, maxHeight: 860),
        child: Container(
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.14),
                blurRadius: 32,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 18,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.pets_rounded,
                        color: primaryColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: AppText(
                                  text: pet.name,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: textPrimaryColor,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (displayId.isNotEmpty) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: AppText(
                                    text: displayId,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          AppText(
                            text: "${pet.categoryTitle ?? 'Pet'} • ${pet.breed ?? 'Breed Unspecified'}",
                            fontSize: 12,
                            color: textSecondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close_rounded,
                        color: textSecondaryColor,
                        size: 22,
                      ),
                      tooltip: "Close",
                    ),
                  ],
                ),
              ),
              Divider(height: 1, thickness: 1, color: borderColor),

              // Scrollable Details Body
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full Pet Photo (NO cropping, clean background)
                      if (imageUrl != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            height: 260,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              border: Border.all(color: borderColor),
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
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
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const SizedBox(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  color: whiteColor.withValues(alpha: 0.4),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Center(
                                        child: Icon(
                                          Icons.pets_rounded,
                                          size: 48,
                                          color: primaryColor
                                              .withValues(alpha: 0.3),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Quick Metric Badges (Weight, Height, Blood Group, Gender, Age)
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _buildMetricChip(
                            icon: Icons.scale_rounded,
                            label: "Weight",
                            value: pet.weight != null
                                ? "${pet.weight} ${pet.weightUnit ?? 'lb'}"
                                : "N/A",
                            color: primaryColor,
                          ),
                          _buildMetricChip(
                            icon: Icons.height_rounded,
                            label: "Height",
                            value: pet.height != null
                                ? "${pet.height} ${pet.heightUnit ?? 'cm'}"
                                : "N/A",
                            color: tertiaryColor,
                          ),
                          _buildMetricChip(
                            icon: Icons.bloodtype_outlined,
                            label: "Blood Group",
                            value: pet.bloodGroup?.isNotEmpty == true
                                ? pet.bloodGroup!
                                : "N/A",
                            color: errorColor,
                          ),
                          _buildMetricChip(
                            icon: pet.gender?.toLowerCase() == 'female'
                                ? Icons.female_rounded
                                : Icons.male_rounded,
                            label: "Gender",
                            value: pet.gender ?? "Unspecified",
                            color: primaryColor,
                          ),
                          if (ageString.isNotEmpty)
                            _buildMetricChip(
                              icon: Icons.cake_outlined,
                              label: "Age",
                              value: ageString,
                              color: yellowColor,
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Description / Notes (if provided)
                      if (pet.description != null &&
                          pet.description!.trim().isNotEmpty) ...[
                        AppText(
                          text: "About / Bio",
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: textPrimaryColor,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: backgroundColor.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor),
                          ),
                          child: AppText(
                            text: pet.description!,
                            fontSize: 13,
                            color: textPrimaryColor,
                            maxLines: 6,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Detailed Specifications Table
                      AppText(
                        text: "Pet Information",
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: textPrimaryColor,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          children: [
                            _buildSpecRow("Pet Name", pet.name),
                            _buildDivider(),
                            _buildSpecRow("Category / Species",
                                pet.categoryTitle ?? "Uncategorized"),
                            _buildDivider(),
                            _buildSpecRow("Breed", pet.breed ?? "Unspecified"),
                            _buildDivider(),
                            _buildSpecRow(
                                "Date of Birth", _formatDob(pet.dob)),
                            _buildDivider(),
                            _buildSpecRow(
                                "Breeder / Kennel", pet.breeder ?? "N/A"),
                            _buildDivider(),
                            _buildSpecRow(
                                "Registry / Microchip", pet.registry ?? "N/A"),
                            if (pet.colour != null &&
                                pet.colour!.isNotEmpty) ...[
                              _buildDivider(),
                              _buildSpecRow("Coat / Colour", pet.colour!),
                            ],
                            if (pet.dailyWalkTarget != null) ...[
                              _buildDivider(),
                              _buildSpecRow("Daily Walk Target",
                                  "${pet.dailyWalkTarget} min"),
                            ],
                            _buildDivider(),
                            _buildSpecRow(
                                "Registered On", _formatDate(pet.createdAt)),
                            if (pet.updatedAt != null) ...[
                              _buildDivider(),
                              _buildSpecRow("Last Updated",
                                  _formatDate(pet.updatedAt)),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Divider(height: 1, thickness: 1, color: borderColor),
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
                      height: 40,
                      width: 100,
                      fontSize: 13,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                text: label,
                fontSize: 10,
                color: textSecondaryColor,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 1),
              AppText(
                text: value,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: textPrimaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: AppText(
              text: label,
              fontSize: 13,
              color: textSecondaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppText(
              text: value,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: borderColor);
  }
}
