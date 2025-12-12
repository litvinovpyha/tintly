import 'package:flutter/material.dart';
import 'package:tintly/shared/designs/app_color.dart';
import 'package:tintly/shared/designs/styles.dart';

class ChoiceDialog extends StatelessWidget {
  const ChoiceDialog({
    super.key,
    required this.title,
    required this.description,
    required this.confirm,
  });
  final String title;
  final String description;
  final String confirm;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:  Text(title, textAlign: TextAlign.center),
      content:  Text(description, textAlign: TextAlign.center),
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColor.primaryColor, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Отмена', style: actionTextStyle),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child:  Text(confirm, style: actionWhiteTextStyle),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
