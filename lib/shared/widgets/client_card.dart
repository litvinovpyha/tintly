import 'package:flutter/material.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/designs/icons.dart';
import 'package:tintly/shared/designs/styles.dart';

class ClientCard extends StatelessWidget {
  const ClientCard({
    super.key,
    required this.label,
    this.onDeleteTap,
    this.onTap,
    required this.role,
    this.selectable,
  });

  final bool? selectable;
  final String? role;
  final String label;
  final Function()? onDeleteTap;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: Dimens.elevation0,
      margin: const EdgeInsets.all(0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: Dimens.height72,
          child: Padding(
            padding: const EdgeInsets.only(
              left: Dimens.padding16,
              right: Dimens.padding16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: Dimens.padding16),
                  child: SizedBox(
                    height: Dimens.height40,
                    width: Dimens.width40,
                    child: Image.asset('assets/images/avatar.png'),
                  ),
                ),

                Expanded(
                  child:  Text(
                    label,
                    style: headingH5TextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (role == 'admin')
                  InkWell(
                    onTap: onDeleteTap,
                    child: Icon(Icons.delete_outlined),
                  ),
                if (role == 'master') chevronRight,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
