import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/brand/bloc/brand_bloc.dart';
import 'package:tintly/features/brand/bloc/brand_event.dart';
import 'package:tintly/features/brand/bloc/brand_state.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/designs/styles.dart';
import 'package:tintly/shared/widgets/choice_dialog.dart';
import 'package:tintly/shared/widgets/edit_dialog.dart';

class BrandList extends StatelessWidget {
  const BrandList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrandBloc, BrandState>(
      builder: (context, state) {
        if (state is BrandLoading) {
          return const Center(
            child: CupertinoActivityIndicator(
              radius: 20.0,
              color: CupertinoColors.activeBlue,
            ),
          );
        } else if (state is BrandError) {
          return Center(child: Text('Ошибка: ${state.message}'));
        } else if (state is BrandLoaded) {
          if (state.brands.isEmpty) {
            return const Center(child: Text('Нет доступных единиц.'));
          }
          return ListView.builder(
            itemCount: state.brands.length,
            itemBuilder: (context, index) {
              final brand = state.brands[index];
              return Card(
                color: Colors.transparent,
                elevation: Dimens.elevation0,
                child: InkWell(
                  onTap: () {},
                  child: SizedBox(
                    height: Dimens.height72,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: Dimens.padding16,
                        right: Dimens.padding16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: Dimens.padding8,
                            ),
                            child: InkWell(
                              onTap: () async {},
                              child: Image.asset(
                                brand.imageUrl ??
                                    'assets/images/bubble_wrap.jpg',
                                height: 30,
                              ),
                            ),
                          ),

                          Expanded(
                            child: Text(
                              brand.name,
                              style: headingH5TextStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          InkWell(
                            child: Icon(Icons.edit),
                            onTap: () async {
                              final newName = await showDialog(
                                context: context,
                                builder: (context) {
                                  return EditDialog(
                                    label: 'Редактировать Название:',
                                    description: '',
                                    confirm: 'Сохранить',
                                    data: brand.name,
                                  );
                                },
                              );

                              if (newName != null && context.mounted) {
                                context.read<BrandBloc>().add(
                                  UpdateBrandByName(brand.id, newName),
                                );
                              }
                            },
                          ),
                          InkWell(
                            child: Icon(Icons.delete_outline),
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
                                context.read<BrandBloc>().add(
                                  DeleteBrand(brand.id),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
        return const Center(child: Text('Инициализация...'));
      },
    );
  }
}
