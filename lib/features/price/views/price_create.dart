import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/brand/bloc/brand_bloc.dart';
import 'package:tintly/features/brand/bloc/brand_event.dart';
import 'package:tintly/features/brand/bloc/brand_state.dart';
import 'package:tintly/features/brand/models/brand.dart';
import 'package:tintly/features/brand/repository/brand_repository.dart';
import 'package:tintly/features/field/models/field.dart';
import 'package:tintly/features/price/bloc/price_bloc.dart';
import 'package:tintly/features/price/bloc/price_event.dart';
import 'package:tintly/features/price/repository/price_repository.dart';
import 'package:tintly/shared/designs/app_color.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/designs/styles.dart';

class PriceCreate extends StatefulWidget {
  final Field field;

  const PriceCreate({super.key, required this.field});

  @override
  State<PriceCreate> createState() => _PriceCreteState();
}

class _PriceCreteState extends State<PriceCreate> {
  final TextEditingController pricePerUnitController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isChecked = false;
  Brand? selectedBrand;
  @override
  // void dispose() {
  //   pricePerUnitController.dispose();
  //   descriptionController.dispose();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PriceBloc(PriceRepository())),
        BlocProvider(
          create: (context) => BrandBloc(BrandRepository())..add(LoadBrands()),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: Text('Создать')),
            body: Padding(
              padding: const EdgeInsets.all(Dimens.padding16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // дропдаун для выбора бренда
                  BlocBuilder<BrandBloc, BrandState>(
                    builder: (context, state) {
                      if (state is BrandLoading) {
                        return CupertinoActivityIndicator(
                          radius: 20.0,
                          color: CupertinoColors.activeBlue,
                        );
                      }

                      if (state is BrandLoaded) {
                        final brands = state.brands;
                        if (selectedBrand == null && brands.isNotEmpty) {
                          selectedBrand = brands.first;
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Бренд: '),
                            SizedBox(width: Dimens.width8),
                            DropdownButton<Brand>(
                              value: selectedBrand,
                              hint: Text("Выберите бренд"),

                              items: brands.map((brand) {
                                return DropdownMenuItem<Brand>(
                                  value: brand,
                                  child: Text(brand.name),
                                );
                              }).toList(),

                              onChanged: (value) {
                                setState(() {
                                  selectedBrand = value;
                                });
                              },
                            ),
                          ],
                        );
                      }

                      return Text("Ошибка загрузки");
                    },
                  ),

                  // передать снаружи поле
                  SizedBox(
                    height: Dimens.height40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Поле: выбор данное поле: '),
                        Text(widget.field.name),
                      ],
                    ),
                  ),

                  TextField(
                    controller: pricePerUnitController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: 'Цена заединицу',
                      hintStyle: const TextStyle(color: Colors.black54),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.6),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Color(0x33000000),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Color(0x33000000),
                          width: 1,
                        ),
                      ),
                    ),
                    cursorColor: Colors.black,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: 'Описание (не обязательно)',
                      hintStyle: const TextStyle(color: Colors.black54),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.6),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Color(0x33000000),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Color(0x33000000),
                          width: 1,
                        ),
                      ),
                    ),
                    cursorColor: Colors.black,
                  ),
                  const SizedBox(height: 16),

                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PriceBloc>().add(
                        CreatePrice(
                          field: widget.field,
                          brand: selectedBrand!,
                          pricePerUnit: double.parse(
                            pricePerUnitController.text,
                          ),
                          placeholder: descriptionController.text,
                        ),
                      );
                      Navigator.pop(context);
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      elevation: Dimens.elevation0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimens.radius15),
                      ),
                    ),
                    child: Text(
                      'Создать',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: whiteTitleTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
