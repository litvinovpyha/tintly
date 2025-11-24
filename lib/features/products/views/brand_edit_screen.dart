import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tintly/features/products/controllers/brand_controller.dart';
import 'package:tintly/features/products/models/brand.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/widgets/choice_dialog.dart';
import 'package:tintly/shared/widgets/custom_app_bar.dart';
import 'package:tintly/shared/widgets/custom_list_tile.dart';
import 'package:tintly/shared/widgets/dialog/edit_dialog.dart';

class BrandEditScreen extends StatefulWidget {
  const BrandEditScreen({super.key});

  @override
  State<BrandEditScreen> createState() => _BrandEditScreenState();
}

class _BrandEditScreenState extends State<BrandEditScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<BrandController>().loadItems();
    });
  }

  void delete(String id) {
    Future.microtask(() async {
      await context.read<BrandController>().delete(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<BrandController>();

    return Scaffold(
      appBar: CustomAppBar(title: 'Редактирование брендов'),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(Dimens.padding16),
        child: Stack(
          children: [
            c.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: c.items.length,
                    itemBuilder: (context, index) {
                      final i = c.items[index];
                      return CustomListTile(
                        leading: Image.asset(i.imageUrl!, height: 30),
                        subtitle: InkWell(
                          child: Icon(Icons.edit),
                          onTap: () async {
                            final value = await showDialog<String>(
                              context: context,
                              builder: (context) {
                                return EditDialog(
                                  label: 'Редактировать:',
                                  description: '',
                                  confirm: 'Сохранить',
                                  data: i.name,
                                );
                              },
                            );

                            if (value == null) return;
                            final item = Brand(
                              id: i.id,
                              imageUrl: i.imageUrl,
                              isActive: i.isActive,
                              placeholder: value,
                              name: value,
                            );

                            await c.update(item);
                          },
                        ),
                        title: i.name,
                        trailing: InkWell(
                          child: Icon(Icons.delete_outline),
                          onTap: () async {
                            bool? confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => ChoiceDialog(
                                title: 'Удалить',
                                description: 'Вы уверены? поле будет удалено',
                                confirm: 'Удалить',
                              ),
                            );

                            if (confirm == true) delete(i.id);
                          },
                        ),
                      );
                    },
                  ),
            // Align(
            //   alignment: AlignmentGeometry.bottomRight,
            //   child: Padding(
            //     padding: const EdgeInsets.all(Dimens.padding24),
            //     child: FloatingActionButton(
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(Dimens.radius10),
            //       ),

            //       backgroundColor: Color(0xFFF8F9FE),
            //       elevation: Dimens.elevation006,
            //       child: Icon(Icons.add, color: Color(0xFF2F3036)),

            //       onPressed: () async {
            //         final result = await showDialog<Map<String, dynamic>>(
            //           context: context,
            //           builder: (context) {
            //             return const EditDialog(
            //               label: 'Создать Бренд:',
            //               description: '',
            //               confirm: 'Создать',
            //               data: "",
            //               image: null,
            //               isImage: true,
            //             );
            //           },
            //         );
            //         print('RESULT: $result');

            //         if (result != null && result.isNotEmpty) {
            //           final i = Brand(
            //             id: '',
            //             name: result['text'] ?? '',
            //             imageUrl: null,
            //             isActive: true,
            //             placeholder: result['text'] ?? '',
            //           );

            //           await c.create(i);
            //         }
            //       },
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
