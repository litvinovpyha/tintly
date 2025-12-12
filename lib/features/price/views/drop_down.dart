import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/field/models/field.dart';
import 'package:tintly/features/price/bloc/price_bloc.dart';
import 'package:tintly/features/price/bloc/price_event.dart';
import 'package:tintly/features/price/bloc/price_state.dart';
import 'package:tintly/features/price/models/price.dart';
import 'package:tintly/features/price/repository/price_repository.dart';

class DropDown extends StatefulWidget {
  final Field? field;
  final bool showAddIcon; // ← добавили

  final Function(Price?)? onChanged;

  const DropDown({
    super.key,
    this.field,
    this.onChanged,
    required this.showAddIcon,
  });

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  Price? selectedPrice;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PriceBloc(PriceRepository())
            ..add(LoadPricesByField(field: widget.field!)),

      child: BlocBuilder<PriceBloc, PriceState>(
        builder: (context, state) {
          if (state is PriceLoading) {
            return const Center(
              child: CupertinoActivityIndicator(
                radius: 20.0,
                color: CupertinoColors.activeBlue,
              ),
            );
          }

          if (state is PriceError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          }

          if (state is PriceLoaded) {
            if (state.price.isEmpty) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/price',
                    arguments: widget.field,
                  );
                },
                child: widget.showAddIcon
                    ? Icon(Icons.add, color: Colors.blue)
                    : SizedBox.shrink(),
              );
            }

            if (selectedPrice == null && state.price.isNotEmpty) {
              selectedPrice = state.price.first;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (widget.onChanged != null) {
                  widget.onChanged!(selectedPrice);
                }
              });
            }

            return DropdownButton<Price>(
              underline: SizedBox(),
              icon: SizedBox(),
              padding: EdgeInsets.zero,
              isExpanded: false,
              value: selectedPrice,
              onChanged: (value) {
                setState(() {
                  selectedPrice = value;
                  widget.onChanged!(selectedPrice);
                });
              },
              items: [
                ...state.price.map(
                  (price) => DropdownMenuItem<Price>(
                    value: price,
                    child: Image.asset(
                      price.brand.imageUrl ?? 'assets/icons/back.png',
                    ),
                  ),
                ),

                DropdownMenuItem<Price>(
                  value: null,
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/price',
                          arguments: widget.field,
                        );
                      },
                      child: widget.showAddIcon
                          ? Icon(Icons.add, color: Colors.blue)
                          : SizedBox.shrink(),
                    ),
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text('Инициализация...'));
        },
      ),
    );
  }
}
