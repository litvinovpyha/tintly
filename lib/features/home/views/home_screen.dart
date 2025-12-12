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

// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:provider/provider.dart';
// import 'package:tintly/features/master/views/calculator_master_page.dart';
// import 'package:tintly/shared/designs/app_color.dart';
// import 'package:tintly/shared/designs/dimens.dart';

// import 'package:tintly/shared/designs/styles.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   String? role;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<CalculatorController>(context, listen: false).loadItems();
//     });
//     Future.microtask(() async {
//       await _loadRole();
//     });
//   }

//   Future<void> _loadRole() async {
//     final box = await Hive.openBox('authBox');
//     setState(() {
//       role = box.get('role');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Consumer<CalculatorController>(
//           builder: (context, calculatorController, child) {
//             if (calculatorController.isLoading) {
//               return const Center(child: CupertinoActivityIndicator(radius: 20.0, color: CupertinoColors.activeBlue));
//             }
//             if (calculatorController.items.isEmpty) {
//               return const Center(child: Text("Нет калькуляторов"));
//             }

//             final calculators = calculatorController.items;
//             return ListView.separated(
//               reverse: true,
//               itemCount: calculators.length,
//               padding: EdgeInsets.only(
//                 top: Dimens.padding16,
//                 left: Dimens.padding16,
//                 right: Dimens.padding16,
//               ),
//               separatorBuilder: (BuildContext context, int index) {
//                 return SizedBox(height: Dimens.height8);
//               },
//               itemBuilder: (context, index) {
//                 final calculator = calculators[index];
//                 return SizedBox(
//                   height: Dimens.height64,
//                   child: Card(
//                     color: AppColor.primaryColor,
//                     margin: EdgeInsets.zero,
//                     elevation: Dimens.elevation006,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(Dimens.radius8),
//                     ),

//                     child: InkWell(
//                       borderRadius: BorderRadius.circular(Dimens.radius8),
//                       onTap: () {
//                         if (role == 'admin') {
//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   CalculatorAdminPage(calculator: calculator),
//                             ),
//                           );
//                         } else {
//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   CalculatorMasterPage(calculator: calculator),
//                             ),
//                           );
//                         }
//                       },

//                       child: Padding(
//                         padding: EdgeInsets.only(
//                           left: Dimens.padding36,
//                           right: Dimens.padding16,
//                         ),
//                         child: Row(
//                           children: [
//                             Text(
//                               calculator.name,
//                               style: whiteTitleTextStyle,
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             Spacer(),
//                             InkWell(
//                               child: Icon(
//                                 Icons.arrow_forward,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//         Positioned(
//           top: 0,
//           left: 0,
//           right: 0,
//           child: GestureDetector(
//             onTap: () {
//               Navigator.pushNamed(context, '/courses/hairstylist');
//             },
//             child: SizedBox(
//               height: 200,

//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     Image.asset(
//                       'assets/courses/hairstylist.jpg',
//                       fit: BoxFit.cover,
//                       height: 200,
//                       errorBuilder: (ctx, err, stack) {
//                         return Center(
//                           child: Icon(
//                             Icons.broken_image,
//                             size: 48,
//                             color: Colors.white54,
//                           ),
//                         );
//                       },
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.bottomCenter,
//                           end: Alignment.topCenter,
//                           colors: [
//                             Colors.black.withOpacity(0.6),
//                             Colors.transparent,
//                           ],
//                         ),
//                       ),
//                       padding: const EdgeInsets.all(12),
//                       alignment: Alignment.bottomLeft,
//                       child: Text(
//                         'УРОКИ ДЛЯ ПАРИКМАХЕРОВ',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
