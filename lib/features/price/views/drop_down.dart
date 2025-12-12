import 'package:flutter/material.dart';
import 'package:tintly/features/price/models/price.dart';

class DropDown extends StatelessWidget {
  final List<Price> prices;
  final Price? selectedPrice;
  final ValueChanged<Price?> onChanged;

  const DropDown({
    super.key,
    required this.prices,
    required this.selectedPrice,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (prices.isEmpty) {
      return const Icon(Icons.check, color: Colors.blue);
    }

    return DropdownButton<Price>(
      underline: const SizedBox(),
      icon: const SizedBox(),
      isExpanded: false,
      value: selectedPrice,
      onChanged: onChanged,
      items: prices
          .map(
            (price) => DropdownMenuItem(
              value: price,
              child: Image.asset(
                price.brand.imageUrl ?? 'assets/icons/back.png',
              ),
            ),
          )
          .toList(),
    );
  }
}
