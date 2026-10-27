import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/config/api_endpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/utils/show_image.dart';
import '../../domain/entities/pet_gallery_entity.dart';
import '../dialogs/pet_gallery_preview_dialog.dart';

class PetGalleryCard extends StatefulWidget {
  final PetGalleryEntity item;

  const PetGalleryCard({super.key, required this.item});

  @override
  State<PetGalleryCard> createState() => _PetGalleryCardState();
}

class _PetGalleryCardState extends State<PetGalleryCard> with AppColors {
  bool _isHovered = false;

  String _resolveImageUrl(String raw) {
    if (raw.trim().isEmpty) return "";
    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      return raw;
    }
    final cleanPath = raw.startsWith('/') ? raw.substring(1) : raw;
    return "${ApiEndpoints.storageBaseUrl}/$cleanPath";
  }

  String _formatDate(String rawDate) {
    if (rawDate.isEmpty) return "N/A";
    try {
      final dateTime = DateTime.parse(rawDate).toLocal();
      return DateFormat('MMM d, yyyy').format(dateTime);
    } catch (_) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => PetGalleryPreviewDialog(item: item),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          transform: Matrix4.translationValues(
            0.0,
            _isHovered ? -2.0 : 0.0,
            0.0,
          ),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _isHovered
                  ? primaryColor.withValues(alpha: 0.5)
                  : borderColor,
              width: _isHovered ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? primaryColor.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.02),
                blurRadius: _isHovered ? 10 : 4,
                offset: Offset(0, _isHovered ? 4 : 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Gallery Image
              ShowImage().buildImage(
                image: _resolveImageUrl(item.imageUrl),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                radius: 0,
              ),

              // 2. Subtle Top-Right Zoom Icon on Hover
              Positioned(
                top: 8,
                right: 8,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 180),
                  opacity: _isHovered ? 1.0 : 0.0,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.fullscreen_rounded,
                      size: 16,
                      color: whiteColor,
                    ),
                  ),
                ),
              ),

              // 3. Subtle Bottom Gradient Overlay
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 28, 12, 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.45),
                        Colors.black.withValues(alpha: 0.85),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Pet Name
                      Row(
                        children: [
                          Icon(Icons.pets_rounded, size: 13, color: whiteColor),
                          const SizedBox(width: 5),
                          Expanded(
                            child: AppText(
                              text: item.petName,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: whiteColor,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      // Created At Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 10,
                                color: whiteColor.withValues(alpha: 0.8),
                              ),
                              const SizedBox(width: 4),
                              AppText(
                                text: _formatDate(item.createdAt),
                                fontSize: 10.5,
                                fontWeight: FontWeight.w500,
                                color: whiteColor.withValues(alpha: 0.85),
                              ),
                            ],
                          ),
                          if (item.remark != null &&
                              item.remark!.trim().isNotEmpty) ...[
                            Icon(
                              Icons.comment_outlined,
                              size: 12,
                              color: whiteColor.withValues(alpha: 0.85),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
