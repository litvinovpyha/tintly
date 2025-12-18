import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/field/bloc/field_bloc.dart';
import 'package:tintly/features/field/bloc/field_event.dart';
import 'package:tintly/features/field/repository/field_repository.dart';
import 'package:tintly/shared/designs/app_color.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/designs/styles.dart';

class FieldCreateScreen extends StatefulWidget {
  const FieldCreateScreen({super.key});

  @override
  State<FieldCreateScreen> createState() => _FieldCreateScreenState();
}

class _FieldCreateScreenState extends State<FieldCreateScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  bool isChecked = false;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FieldBloc(FieldRepository()),

      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: Text('Создать')),
            body: Padding(
              padding: const EdgeInsets.all(Dimens.padding16),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  TextField(
                    controller: nameController,
                    textCapitalization: TextCapitalization.words,

                    decoration: InputDecoration(
                      hintText: 'Название',
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
                      hintText: 'Описание например "Грамм" ( не обязательно )',
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

                  Row(
                    children: [
                      CupertinoSwitch(
                        value: isChecked,
                        onChanged: (v) => setState(() => isChecked = v),
                      ),
                      const Text("Поле с фиксированной ставкой "),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FieldBloc>().add(
                        CreateField(
                          nameController.text,
                          descriptionController.text,
                          unitController.text,
                          true,
                          isChecked,
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
