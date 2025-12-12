import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/calculatorSession/bloc/calculator_session_bloc.dart';
import 'package:tintly/features/calculatorSession/bloc/calculator_session_event.dart';
import 'package:tintly/features/calculatorSession/repository/calculator_session_repository.dart';

import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/designs/icons.dart';
import 'package:tintly/shared/widgets/choice_dialog.dart';
import 'package:tintly/shared/widgets/custom_list_tile.dart';

class HistoryEditScreen extends StatelessWidget {
  const HistoryEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CalculatorSessionBloc>(
      create: (context) =>
          CalculatorSessionBloc(CalculatorSessionRepository())
            ..add(LoadCalculatorSessions()),
      child: Builder(
        builder: (blocContext) {
          return Scaffold(
            appBar: AppBar(title: Text('История')),
            body: Padding(
              padding: const EdgeInsetsGeometry.all(Dimens.padding16),
              child: Column(
                children: [
                  CustomListTile(
                    title: 'Очистить историю приложения',
                    trailing: chevronRight,
                    onTap: () async {
                      bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => ChoiceDialog(
                          title: 'Удалить',
                          description: 'Вы уверены? Вся история будет удалена.',
                          confirm: 'Удалить',
                        ),
                      );

                      if (confirm == true && context.mounted) {
                        blocContext.read<CalculatorSessionBloc>().add(
                          ClearAllSessions(),
                        );
                      }
                    },
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
