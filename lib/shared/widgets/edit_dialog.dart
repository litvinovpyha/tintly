import 'package:flutter/material.dart';
import 'package:tintly/shared/designs/app_color.dart';
import 'package:tintly/shared/designs/styles.dart';

class EditDialog extends StatefulWidget {
  const EditDialog({
    super.key,
    required this.label,
    required this.description,
    required this.confirm,
    required this.data,
  });

  final String label;
  final String description;
  final String confirm;
  final String data;

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.data);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.label, textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.description, textAlign: TextAlign.center),
          const SizedBox(height: 16),

          TextField(
            controller: _controller,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "Новое значение",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(null),
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
                onPressed: () {
                  Navigator.of(context).pop(_controller.text);
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(widget.confirm, style: actionWhiteTextStyle),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
