import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/constants.dart';
import '../presentation/widgets/app_text.dart';

class DialogUtils {
  static void showDynamicConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    String cancelText = "Cancel",
    String confirmText = "Confirm",
    double maxWidth = 420,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: AppColorsHelper().whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppConstantsHelper().radiusMedium,
            ),
            side: BorderSide(
              color: AppColorsHelper().borderColor,
              width: AppConstantsHelper().smallBorder,
            ),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: AppConstantsHelper().largeSpace),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AppText(
                    text: title,
                    fontSize: AppConstantsHelper().fontXlText,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: AppConstantsHelper().normalSpace),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: AppText(
                    text: message,
                    color: AppColorsHelper().textSecondaryColor,
                    fontSize: AppConstantsHelper().fontBaseText,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                  ),
                ),
                SizedBox(height: AppConstantsHelper().largeSpace),
              Divider(
                height: AppConstantsHelper().border,
                thickness: AppConstantsHelper().border,
                color: AppColorsHelper().borderColor,
              ),
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(dialogContext);
                          if (onCancel != null) {
                            onCancel();
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: AppConstantsHelper().smMediumSpace,
                          ),
                          alignment: Alignment.center,
                          child: AppText(
                            text: cancelText,
                            fontSize: AppConstantsHelper().fontLgText,
                            color: AppColorsHelper().textSecondaryColor,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: AppConstantsHelper().border,
                      height: AppConstantsHelper().xxLargeSpace,
                      color: AppColorsHelper().borderColor,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(dialogContext);
                          onConfirm();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: AppConstantsHelper().smMediumSpace,
                          ),
                          alignment: Alignment.center,
                          child: AppText(
                            text: confirmText,
                            style: TextStyle(
                              fontSize: AppConstantsHelper().fontLgText,
                              color: AppColorsHelper().primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
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
}
