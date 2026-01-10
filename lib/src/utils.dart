import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'components/custom_modal_bottom_sheet.dart';
import 'constants.dart';

class Utils {
  static int yearsLength(int firstYear, int lastYear) =>
      lastYear - firstYear + 1;

  static Future<T?> showCustomModalBottomSheet<T>({
    required BuildContext context,
    required Widget Function(BuildContext) builder,
    Color? backgroundColor,
    String? barrierLabel,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    Color? barrierColor,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    bool? showDragHandle,
    bool useSafeArea = false,
    RouteSettings? routeSettings,
    AnimationController? transitionAnimationController,
    Offset? anchorPoint,
    AnimationStyle? sheetAnimationStyle,
    bool? requestFocus,
  }) {
    final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
    final localizations = MaterialLocalizations.of(context);
    return navigator.push(
      CustomModalBottomSheetRoute<T>(
        builder: builder,
        capturedThemes:
            InheritedTheme.capture(from: context, to: navigator.context),
        barrierLabel: barrierLabel ?? localizations.scrimLabel,
        barrierOnTapHint:
            localizations.scrimOnTapHint(localizations.bottomSheetLabel),
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        clipBehavior: clipBehavior,
        constraints: constraints,
        isDismissible: isDismissible,
        modalBarrierColor: barrierColor ??
            Theme.of(context).bottomSheetTheme.modalBarrierColor,
        enableDrag: enableDrag,
        showDragHandle: showDragHandle,
        settings: routeSettings,
        transitionAnimationController: transitionAnimationController,
        anchorPoint: anchorPoint,
        useSafeArea: useSafeArea,
        sheetAnimationStyle: sheetAnimationStyle,
        requestFocus: requestFocus,
      ),
    );
  }

  static Widget buildCarouselSlider({
    required CarouselSliderController controller,
    required int itemCount,
    required int initialPage,
    required void Function(int index) onPageChanged,
    required Widget Function(int index) itemChild,
  }) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return CarouselSlider(
            carouselController: controller,
            options: CarouselOptions(
              aspectRatio: constraints.maxWidth / constraints.maxHeight,
              initialPage: initialPage,
              enlargeFactor: 0.38,
              viewportFraction: 0.3,
              scrollDirection: Axis.vertical,
              enlargeCenterPage: true,
              onPageChanged: (index, _) => onPageChanged(index),
            ),
            items: List.generate(
              itemCount,
              (index) => GestureDetector(
                onTap: () {
                  controller.animateToPage(
                    index,
                    duration: spinnerAnimationDuration,
                  );
                },
                child: itemChild(index),
              ),
            ),
          );
        },
      ),
    );
  }
}
