import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/app/main_screen.dart';
import 'package:tintly/core/auth/bloc/auth_bloc.dart';
import 'package:tintly/core/auth/bloc/auth_state.dart';
import 'package:tintly/features/calculator/bloc/calculator_bloc.dart';
import 'package:tintly/features/calculator/bloc/calculator_state.dart';
import 'package:tintly/features/calculatorSession/bloc/calculator_session_bloc.dart';
import 'package:tintly/features/calculatorSession/bloc/calculator_session_event.dart';
import 'package:tintly/shared/designs/app_color.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/designs/styles.dart';

class SaveButton extends StatefulWidget {
  final double total;
  final String calculatorId;

  const SaveButton({
    super.key,
    required this.total,
    required this.calculatorId,
  });

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  final TextEditingController discountController = TextEditingController();
  double discount = 0;

  double get finalTotal => (widget.total - discount).clamp(0, double.infinity);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.padding16),
      child: ElevatedButton(
        onPressed: () {
          final calcState = context.read<CalculatorBloc>().state;
          String? calculatorName;

          if (calcState is CalculatorsLoaded) {
            final calculator = calcState.calculators.firstWhere(
              (c) => c.id == widget.calculatorId,
            );
            calculatorName = calculator.name;
          }

          if (calculatorName == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Название калькулятора не найдено")),
            );
            return;
          }

          final authState = context.read<AuthBloc>().state;
          String? userId;

          if (authState is Authenticated) {
            userId = authState.user.id;
          }

          if (userId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Пользователь не найден")),
            );
            return;
          }

          context.read<CalculatorSessionBloc>().add(
            AddCalculatorSession(
              userId: userId,
              clientId: null,
              calculatorId: widget.calculatorId,
              totalAmount: finalTotal,
              calculatorName: calculatorName,
            ),
          );

          if (context.mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Сессия сохранена")));

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(400, Dimens.height125),
          maximumSize: Size.fromHeight(Dimens.height125),
          backgroundColor: AppColor.primaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.radius15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Итого: ${finalTotal.toInt()}', style: whiteTitleTextStyle),

            SizedBox(
              width: 90,
              child: TextField(
                controller: discountController,
                keyboardType: TextInputType.number,
                style: whiteTitleTextStyle.copyWith(fontSize: 20),
                decoration: const InputDecoration(
                  hintText: "Скидка",
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    discount = double.tryParse(value) ?? 0;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
