import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/field/models/field.dart';
import 'package:tintly/features/price/bloc/price_bloc.dart';
import 'package:tintly/features/price/bloc/price_event.dart';
import 'package:tintly/features/price/repository/price_repository.dart';
import 'package:tintly/features/price/views/price_list.dart';
import 'package:tintly/shared/designs/dimens.dart';

class PriceScreen extends StatelessWidget {
  final Field? field;
  const PriceScreen({super.key, this.field});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PriceBloc(PriceRepository())..add(LoadPricesByField(field: field!)),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: Text('Прайсы: ${field!.name}')),
            body: PriceList(),
            floatingActionButton: FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens.radius10),
              ),

              backgroundColor: Color(0xFFF8F9FE),
              elevation: Dimens.elevation006,
              child: Icon(Icons.add, color: Color(0xFF2F3036)),
              onPressed: () async {
                await Navigator.pushNamed(
                  context,
                  '/price/create',
                  arguments: field,
                );

                if (context.mounted) {
                  context.read<PriceBloc>().add(
                    LoadPricesByField(field: field!),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
