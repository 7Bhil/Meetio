import 'package:flutter/material.dart';
import '../constants/app_assets.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';

enum LogoType {
  primary,
  auth,
  header,
  standalone,
}

class LogoWidget extends StatelessWidget {
  final LogoType type;
  final double? size;
  final bool showText;
  final Color? iconColor;
  final TextStyle? textStyle;

  const LogoWidget({
    super.key,
    this.type = LogoType.primary,
    this.size,
    this.showText = true,
    this.iconColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final double iconSize = size ?? _getDefaultSize();
    final Color iconColor = this.iconColor ?? _getDefaultIconColor();
    final IconData iconData = _getIconData();
    final TextStyle textStyle = this.textStyle ?? _getDefaultTextStyle();

    if (type == LogoType.standalone) {
      return _buildStandaloneLogo(iconSize, iconColor);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (type == LogoType.header) ...[
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              iconData,
              color: Colors.white,
              size: iconSize,
            ),
          ),
          const SizedBox(width: 12),
        ] else ...[
          Icon(
            iconData,
            color: iconColor,
            size: iconSize,
          ),
          const SizedBox(width: 8),
        ],
        if (showText)
          Text(
            'Meetio',
            style: textStyle,
          ),
      ],
    );
  }

  Widget _buildStandaloneLogo(double iconSize, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        AppAssets.logoIcon,
        color: iconColor,
        size: iconSize,
      ),
    );
  }

  IconData _getIconData() {
    switch (type) {
      case LogoType.auth:
        return AppAssets.logoIconAuth;
      case LogoType.primary:
      case LogoType.header:
      case LogoType.standalone:
      default:
        return AppAssets.logoIcon;
    }
  }

  double _getDefaultSize() {
    switch (type) {
      case LogoType.auth:
        return AppAssets.logoSizeLarge;
      case LogoType.header:
        return AppAssets.logoSizeDefault;
      case LogoType.primary:
      case LogoType.standalone:
      default:
        return AppAssets.logoSizeDefault;
    }
  }

  Color _getDefaultIconColor() {
    switch (type) {
      case LogoType.auth:
      case LogoType.primary:
        return AppColors.primary;
      case LogoType.header:
        return Colors.white;
      case LogoType.standalone:
        return AppColors.primary;
      default:
        return AppColors.primary;
    }
  }

  TextStyle _getDefaultTextStyle() {
    switch (type) {
      case LogoType.header:
        return AppTextStyles.headlineLarge.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.5,
        );
      case LogoType.auth:
        return AppTextStyles.headlineMedium.copyWith(
          color: AppColors.primary,
        );
      case LogoType.primary:
      case LogoType.standalone:
      default:
        return AppTextStyles.headlineMedium.copyWith(
          color: AppColors.primary,
        );
    }
  }
}
