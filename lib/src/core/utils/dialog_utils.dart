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
            borderRadius: BorderRadius.circular(AppConstantsHelper().radiusMedium),
            side: BorderSide(
              color: AppColorsHelper().borderColor,
              width: AppConstantsHelper().smallBorder,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: AppConstantsHelper().largeSpace),
              AppText(
                text: title,
                fontSize: AppConstantsHelper().fontXlText,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: AppConstantsHelper().normalSpace),
              AppText(
                text: message,
                color: AppColorsHelper().textSecondaryColor,
                fontSize: AppConstantsHelper().fontBaseText,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
                maxLines: 2,
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
                          padding: EdgeInsets.symmetric(vertical: AppConstantsHelper().smMediumSpace),
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
                          padding: EdgeInsets.symmetric(vertical: AppConstantsHelper().smMediumSpace),
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
        );
      },
    );
  }
}
