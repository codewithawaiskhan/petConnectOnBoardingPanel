import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/utils/show_image.dart';
import '../../../../core/utils/show_toast.dart';
import '../../domain/entities/influencer_entity.dart';
import '../providers/my_team_provider.dart';

class RequestInfluencerDialog extends StatefulWidget {
  const RequestInfluencerDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const RequestInfluencerDialog(),
    );
  }

  @override
  State<RequestInfluencerDialog> createState() =>
      _RequestInfluencerDialogState();
}

class _RequestInfluencerDialogState extends State<RequestInfluencerDialog>
    with AppColors {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _referralCodeController = TextEditingController();
  final ShowImage _showImage = ShowImage();

  ReferredUserLookupEntity? _foundUser;

  @override
  void dispose() {
    _referralCodeController.dispose();
    super.dispose();
  }

  Future<void> _onSearch(MyTeamProvider provider) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final user = await provider.searchUserByReferralCode(
      _referralCodeController.text.trim(),
    );

    if (!mounted) return;
    if (user == null) {
      setState(() => _foundUser = null);
      showToast(context, 'User not found or invalid code', isError: true);
      return;
    }

    setState(() => _foundUser = user);
  }

  Future<void> _onSendRequest(MyTeamProvider provider) async {
    if (_foundUser == null) return;

    final success = await provider.requestInfluencerAssignment(
      _foundUser!.id,
      context,
    );
    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Widget _buildUserAvatar(ReferredUserLookupEntity user) {
    final image = user.image;
    final initial = user.fullName.isNotEmpty
        ? user.fullName.substring(0, 1).toUpperCase()
        : "U";

    if (image != null && image.trim().isNotEmpty) {
      return _showImage.buildImage(image: image.trim(), size: 42);
    }

    return CircleAvatar(
      radius: 21,
      backgroundColor: primaryColor.withValues(alpha: 0.12),
      child: AppText(
        text: initial,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyTeamProvider>(
      builder: (context, provider, _) {
        final isBusy = provider.isSearchingUser || provider.isSubmitting;

        return Dialog(
          backgroundColor: whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 480,
              maxHeight: MediaQuery.sizeOf(context).height * 0.85,
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.person_add_alt_1_rounded,
                            color: primaryColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: "Add Influencer via Referral Code",
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: textPrimaryColor,
                              ),
                              const SizedBox(height: 2),
                              AppText(
                                text:
                                    "Search for a Pet Parent by their referral code",
                                fontSize: 12,
                                color: textSecondaryColor,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: isBusy
                              ? null
                              : () => Navigator.of(context).pop(false),
                          icon: Icon(
                            Icons.close_rounded,
                            color: textSecondaryColor,
                            size: 20,
                          ),
                          tooltip: "Close",
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Divider(color: borderColor, height: 1),
                    const SizedBox(height: 20),
                    AppText(
                      text: "Referral Code *",
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textPrimaryColor,
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _referralCodeController,
                      hintText: "Enter referral code",
                      maxLines: 1,
                      radius: 10,
                      isEnable: !isBusy,
                      onChanged: (_) {
                        if (_foundUser != null) {
                          setState(() => _foundUser = null);
                        }
                      },
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return "Please enter a referral code";
                        }
                        return null;
                      },
                    ),
                    if (_foundUser != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: primaryColor.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Row(
                          children: [
                            _buildUserAvatar(_foundUser!),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    text: _foundUser!.fullName.isNotEmpty
                                        ? _foundUser!.fullName
                                        : "Pet Parent",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: textPrimaryColor,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (_foundUser!.email != null &&
                                      _foundUser!.email!.isNotEmpty)
                                    AppText(
                                      text: _foundUser!.email!,
                                      fontSize: 12,
                                      color: textSecondaryColor,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  if (_foundUser!.referralCode != null &&
                                      _foundUser!.referralCode!.isNotEmpty)
                                    AppText(
                                      text:
                                          "Code: ${_foundUser!.referralCode!}",
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor,
                                    ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.check_circle_rounded,
                              color: successColor,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomButton(
                          text: "Cancel",
                          height: 42,
                          width: 110,
                          radius: 8,
                          isOutlined: true,
                          fontSize: 13,
                          onTap: isBusy
                              ? null
                              : () => Navigator.of(context).pop(false),
                        ),
                        const SizedBox(width: 12),
                        CustomButton(
                          text: _foundUser == null ? "Search" : "Send Request",
                          height: 42,
                          width: 140,
                          radius: 8,
                          fontSize: 13,
                          isLoading: isBusy,
                          onTap: isBusy
                              ? null
                              : (_foundUser == null
                                    ? () => _onSearch(provider)
                                    : () => _onSendRequest(provider)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
