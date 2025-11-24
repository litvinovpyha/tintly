import 'package:flutter/widgets.dart';
import '../designs/dimens.dart';

double getListBottomPadding(BuildContext context) =>
    ((MediaQuery.of(context).padding.bottom + Dimens.height8) * 2 + Dimens.height40);
