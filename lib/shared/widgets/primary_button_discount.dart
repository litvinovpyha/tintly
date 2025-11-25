import 'package:flutter/material.dart';
import 'package:tintly/shared/designs/styles.dart';
import '../designs/app_color.dart';
import '../designs/dimens.dart';

class PrimaryButtonWithDiscount extends StatefulWidget {
  final double total;
  final void Function(double finalTotal) onSave;

  const PrimaryButtonWithDiscount({
    super.key,
    required this.total,
    required this.onSave,
  });

  @override
  State<PrimaryButtonWithDiscount> createState() =>
      _PrimaryButtonWithDiscountState();
}

class _PrimaryButtonWithDiscountState extends State<PrimaryButtonWithDiscount> {
  final TextEditingController _discountController = TextEditingController();
  double _discount = 0;

  @override
  void initState() {
    super.initState();
    _discountController.addListener(() {
      setState(() {
        final value = double.tryParse(_discountController.text);
        _discount = value != null ? value : 0;
      });
    });
  }

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double finalTotal = (widget.total - _discount).clamp(
      0,
      double.infinity,
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColor.primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Итого: ${finalTotal.toStringAsFixed(0)}',
                style: whiteTitleTextStyle,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 100,
              child: TextField(
                controller: _discountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                
                decoration: const InputDecoration(
                  hintText: 'Скидка',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                  
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.check, color: Colors.white),
              onPressed: () {
                final discount = double.tryParse(_discountController.text) ?? 0;
                final double finalTotal = (widget.total - discount).clamp(
                  0,
                  double.infinity,
                );

                widget.onSave(finalTotal);
              },
            ),
          ],
        ),
      ),
    );
  }
}
