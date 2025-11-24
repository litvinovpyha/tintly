import 'package:flutter/material.dart';
import 'package:tintly/shared/designs/styles.dart';
import '../designs/app_color.dart';
import '../designs/dimens.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const PrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          left: Dimens.padding16,
          right: Dimens.padding16,
          bottom: Dimens.padding8,
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(400, Dimens.height125),
            maximumSize: Size.fromHeight(Dimens.height125),
            backgroundColor: AppColor.primaryColor,
            elevation: Dimens.elevation0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimens.radius15),
            ),
            padding: const EdgeInsets.only(
              left: Dimens.padding16,
              right: Dimens.padding16,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: whiteTitleTextStyle,
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
