import 'package:flutter/material.dart';

class PerilakuGulirSiaga extends MaterialScrollBehavior {
  const PerilakuGulirSiaga();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context)
      ? const ClampingScrollPhysics()
      : const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;
}
