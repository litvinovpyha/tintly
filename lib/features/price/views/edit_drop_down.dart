import 'package:flutter/material.dart';
import 'package:tintly/features/field/models/field.dart';
import 'package:tintly/features/price/models/price.dart';

class EditDropDown extends StatefulWidget {
  final Field field;
  final List<Price> prices;
  final Price? selectedPrice;
  final bool showAddIcon;
  final Function(Price?)? onChanged;

  const EditDropDown({
    super.key,
    required this.field,
    required this.prices,
    this.selectedPrice,
    required this.showAddIcon,
    this.onChanged,
  });

  @override
  State<EditDropDown> createState() => _EditDropDownState();
}

class _EditDropDownState extends State<EditDropDown> {
  Price? selectedPrice;

  @override
  void initState() {
    super.initState();
    selectedPrice = widget.selectedPrice;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.prices.isEmpty) {
      return widget.showAddIcon
          ? InkWell(
              onTap: () => Navigator.pushNamed(
                context,
                '/price',
                arguments: widget.field,
              ),
              child: Icon(Icons.add, color: Colors.blue),
            )
          : const Icon(Icons.check, color: Colors.blue);
    }
 return DropdownButton<Price>(
  underline: SizedBox(),
  icon: SizedBox(),
  isExpanded: false,
  value: selectedPrice,
  onChanged: (p) {
    setState(() => selectedPrice = p);
    widget.onChanged?.call(p);
  },
  items: [
    if (widget.showAddIcon)
      DropdownMenuItem(
        value: null,
        child: InkWell(
          onTap: () => Navigator.pushNamed(
            context,
            '/price',
            arguments: widget.field,
          ),
          child: Icon(Icons.add, color: Colors.blue),
        ),
      ),
    ...widget.prices.map(
      (price) => DropdownMenuItem(
        value: price,
        child: Image.asset(price.brand.imageUrl ?? 'assets/icons/back.png'),
      ),
    ),
  ],
);

  }
}
