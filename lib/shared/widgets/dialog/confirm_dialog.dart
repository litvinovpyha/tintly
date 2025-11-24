import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.content,
    required this.onConfirm,
    required this.title,
  });
  final String content;
  final String title;
  final VoidCallback onConfirm;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:  Text(title),
      content:  Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm();
            Navigator.pop(context, true);
          },
          child: const Text('Удалить'),
        ),
      ],
    );
  }
}
