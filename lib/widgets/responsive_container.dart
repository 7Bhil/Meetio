import 'package:flutter/material.dart';
import '../constants/breakpoints.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final bool enableMaxWidth;
  final EdgeInsets? padding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.enableMaxWidth = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double maxWidth = enableMaxWidth ? 1200 : double.infinity;

        return Container(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
            minWidth: 320,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: Breakpoints.horizontalPadding(width),
          ),
          padding: padding ?? EdgeInsets.zero,
          child: child,
        );
      },
    );
  }
}