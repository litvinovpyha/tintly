import 'package:flutter/material.dart';
import 'package:tintly/shared/designs/icons.dart';
import 'package:tintly/shared/designs/styles.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool? divider;
  final Function()? onTap;

  const CustomListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.divider = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: leading,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: darkestTextStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 6),
              if (subtitle != null)
                Flexible(
                  flex: 0, // не растягивается
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 100,
                    ), // ограничиваем ширину
                    child: subtitle!,
                  ),
                ),
            ],
          ),
          trailing: trailing,
        ),
        if (divider == true) greyDivider,
      ],
    );
  }
}
