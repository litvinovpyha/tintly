import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/price/bloc/price_bloc.dart';
import 'package:tintly/features/price/bloc/price_event.dart';
import 'package:tintly/features/price/bloc/price_state.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/widgets/choice_dialog.dart';
import 'package:tintly/shared/widgets/edit_dialog.dart';

class PriceList extends StatelessWidget {
  const PriceList({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PriceBloc, PriceState>(
      builder: (context, state) {
        if (state is PriceLoading) {
          return const Center(
            child: CupertinoActivityIndicator(
              radius: 20.0,
              color: CupertinoColors.activeBlue,
            ),
          );
        } else if (state is PriceError) {
          return Center(child: Text('Ошибка: ${state.message}'));
        } else if (state is PriceLoaded) {
          if (state.price.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Нет доступных прайсов.'),
                  Text('Создайте новое'),
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(Dimens.padding16),
            child: ListView.builder(
              itemCount: state.price.length,
              itemBuilder: (context, index) {
                final price = state.price[index];

                return Card(
                  color: Colors.white,
                  child: ListTile(
                    title: Text('${price.brand.name} - ${price.field.name}'),
                    subtitle: Text(
                      'Цена за единицу: ${price.pricePerUnit.toInt()}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min, // <-- важно
                      children: [
                        InkWell(
                          onTap: () async {
                            final newPricePerUnit = await showDialog(
                              context: context,
                              builder: (context) {
                                return EditDialog(
                                  label: 'Редактировать прайс:',
                                  description: '',
                                  confirm: 'Сохранить',
                                  data: price.pricePerUnit.toInt().toString(),
                                );
                              },
                            );

                            if (newPricePerUnit != null && context.mounted) {
                              context.read<PriceBloc>().add(
                                UpdatePricePerUnit(
                                  price.id,
                                  newPricePerUnit.toString(),
                                ),
                              );
                            }
                          },
                          child: const Icon(Icons.edit, color: Colors.grey),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () async {
                            bool? confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => ChoiceDialog(
                                title: 'Удалить',
                                description: 'Вы уверены?',
                                confirm: 'Удалить',
                              ),
                            );

                            if (confirm == true && context.mounted) {
                              context.read<PriceBloc>().add(
                                DeletePrice(price.id),
                              );
                            }
                          },
                          child: const Icon(Icons.delete, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const Center(child: Text('Инициализация...'));
      },
    );
  }
}
