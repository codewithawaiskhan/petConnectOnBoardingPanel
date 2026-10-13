import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/constants.dart';
import '../presentation/widgets/app_text.dart';

class CustomAnimatedToast extends StatefulWidget {
  final String message;
  final VoidCallback onDismissed;

  const CustomAnimatedToast({
    super.key,
    required this.message,
    required this.onDismissed,
  });

  static void show(BuildContext context, String message) {
    final overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return CustomAnimatedToast(
          message: message,
          onDismissed: () {
            if (overlayEntry.mounted) {
              overlayEntry.remove();
            }
          },
        );
      },
    );

    overlayState.insert(overlayEntry);
  }

  @override
  State<CustomAnimatedToast> createState() => _CustomAnimatedToastState();
}

class _CustomAnimatedToastState extends State<CustomAnimatedToast>
    with TickerProviderStateMixin, AppColors, Constants {
  late AnimationController _entryController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _offsetAnimation;
  late Animation<double> _entryFadeAnimation;

  late AnimationController _exitController;
  late Animation<double> _exitFadeAnimation;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutQuad),
    );

    _offsetAnimation = Tween<double>(begin: 10.0, end: 0.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutQuad),
    );

    _entryFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOut));

    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _exitFadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _exitController, curve: Curves.easeIn));

    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    _entryController.forward();
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      await _exitController.forward();
      widget.onDismissed();
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPosition = MediaQuery.of(context).size.height * 0.4;

    return Positioned(
      top: topPosition,
      left: 50,
      right: 50,
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([_entryController, _exitController]),
            builder: (context, child) {
              final opacity =
                  _exitController.isAnimating || _exitController.isCompleted
                  ? _exitFadeAnimation.value
                  : _entryFadeAnimation.value;

              return Opacity(
                opacity: opacity,
                child: Transform.translate(
                  offset: Offset(0, _offsetAnimation.value),
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    alignment: Alignment.center,
                    child: child,
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: largeSpace,
                vertical: normalSpace,
              ),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(radiusSmall),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: primaryColor,
                    size: barIconSize,
                  ),
                  SizedBox(height: smMediumSpace),
                  AppText(
                    text: widget.message,
                    fontSize: fontLgText,
                    fontWeight: FontWeight.w500,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void successMessage(BuildContext context, String message) {
  CherryToast.success(
    animationDuration: const Duration(seconds: 1),
    autoDismiss: true,
    animationType: AnimationType.fromTop,
    title: Text(
      message,
      maxLines: 2,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    ),
  ).show(context);
}

void errorMessage(BuildContext context, String message) {
  CherryToast.error(
    description: Text(
      message,
      maxLines: 2,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    ),
    animationType: AnimationType.fromTop,
    animationDuration: const Duration(milliseconds: 1000),
    autoDismiss: true,
  ).show(context);
}

void showToast(BuildContext context, String message, {bool isError = false}) {
  if (isError) {
    errorMessage(context, message);
  } else {
    successMessage(context, message);
  }
}
