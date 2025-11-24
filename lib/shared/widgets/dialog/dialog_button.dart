import 'package:flutter/material.dart';
import 'package:tintly/shared/designs/styles.dart';
import '../../designs/app_color.dart';
import '../../designs/dimens.dart';

class DialogButton extends StatelessWidget {
  final String title;
  final Function() onTap;
  const DialogButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(Dimens.width200, Dimens.height40),
        maximumSize: Size.fromHeight(Dimens.height40),
        backgroundColor: AppColor.primaryColor,
        elevation: Dimens.elevation0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.radius15),
        ),
      ),
      child:  Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: titleTextStyle,
      ),
    );
  }
}
