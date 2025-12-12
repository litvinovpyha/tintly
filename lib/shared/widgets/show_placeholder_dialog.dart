import 'package:flutter/material.dart';
import 'package:tintly/shared/designs/dimens.dart';

Future<void> showPlaceholderDialog(
  BuildContext context, {
  String title = 'В разработке',
  String message = 'Эта функция пока не реализована.',
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Ок'),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radius10),
      ),
    ),
  );
}
