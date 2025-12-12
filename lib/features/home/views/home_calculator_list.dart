import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/core/routes/app_routes.dart';
import 'package:tintly/features/calculator/bloc/calculator_bloc.dart';
import 'package:tintly/features/calculator/bloc/calculator_state.dart';
import 'package:tintly/shared/designs/app_color.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/designs/styles.dart';

class HomeCalculatorList extends StatelessWidget {
  const HomeCalculatorList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalculatorBloc, CalculatorState>(
      builder: (context, state) {
        if (state is CalculatorLoading) {
          return const Center(
            child: CupertinoActivityIndicator(
              radius: 20.0,
              color: CupertinoColors.activeBlue,
            ),
          );
        } else if (state is CalculatorError) {
          return Center(child: Text('Ошибка: ${state.message}'));
        } else if (state is CalculatorsLoaded) {
          if (state.calculators.isEmpty) {
            return const Center(child: Text('Нет доступных единиц.'));
          }

          return ListView.builder(
            reverse: true,
            itemCount: state.calculators.length,
            itemBuilder: (context, index) {
              final calculator = state.calculators[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Card(
                  color: AppColor.primaryColor,
                  margin: EdgeInsets.zero,
                  elevation: Dimens.elevation006,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimens.radius8),
                  ),

                  child: InkWell(
                    onTap: () => Navigator.of(context).pushNamed(
                      RouteNames.calculating,
                      arguments: calculator.id,
                    ),
                    child: SizedBox(
                      height: Dimens.height64,

                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: Dimens.padding16,
                          right: Dimens.padding16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                calculator.name,
                                style: whiteTitleTextStyle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            InkWell(
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                              onTap: () async {},
                            ),
                          ],
                        ),
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
