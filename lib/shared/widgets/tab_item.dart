import 'package:flutter/material.dart';
import '../designs/app_color.dart';
import '../designs/dimens.dart';

class TabItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isSelected;
  final GestureTapCallback? onTap;
  const TabItem({
    super.key,
    required this.text,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(
          left: Dimens.padding8,
          right: Dimens.padding8,
          top: Dimens.padding6,
          bottom: Dimens.padding6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              color: isSelected ? AppColor.primaryColor : AppColor.greyColor,
              size: 24,
            ),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? AppColor.primaryColor : AppColor.greyColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: Dimens.fontSize11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
