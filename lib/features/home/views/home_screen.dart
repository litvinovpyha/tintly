import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/core/routes/app_routes.dart';
import 'package:tintly/features/calculator/bloc/calculator_bloc.dart';
import 'package:tintly/features/calculator/bloc/calculator_event.dart';
import 'package:tintly/features/calculator/repository/calculator_repository.dart';
import 'package:tintly/features/home/views/home_calculator_list.dart';
import 'package:tintly/shared/designs/app_color.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CalculatorBloc(CalculatorRepository())..add(LoadCalculators()),
      child: Column(
        children: [
          InkWell(
            onTap: () =>
                Navigator.of(context).pushNamed(RouteNames.hairCousesList),
            child: Container(
              height: 150,
              color: AppColor.primaryColor,
              alignment: Alignment.center,

              child: const Text(
                'Онлайн курс для парикмахеров',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),

          const Expanded(child: HomeCalculatorList()),
        ],
      ),
    );
  }
}
