import 'package:flutter/material.dart';
import '../../designs/dimens.dart';
import 'dialog_button.dart';

class ErrorDialog extends StatelessWidget {
  final String description;
  const ErrorDialog({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radius8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimens.padding16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ooops...'),
            SizedBox(height: Dimens.padding8),
             Text(description),
            SizedBox(height: Dimens.padding20),
            Center(
              child: DialogButton(
                title: 'OK',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
