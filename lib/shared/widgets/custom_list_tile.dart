import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool divider;
  final VoidCallback? onTap;

  const CustomListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.divider = true,
    this.onTap,
  });

  bool get _isIOS => defaultTargetPlatform == TargetPlatform.iOS;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _isIOS ? _buildCupertino(context) : _buildMaterial(context),
        if (divider) _buildDivider(context),
      ],
    );
  }

  Widget _buildMaterial(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: leading,
      trailing: trailing,
      title: _titleRow(context),
    );
  }

  Widget _buildCupertino(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onPressed: onTap,
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 12)],
          Expanded(child: _titleRow(context)),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ] else
            const Icon(
              CupertinoIcons.chevron_forward,
              size: 18,
              color: CupertinoColors.systemGrey,
            ),
        ],
      ),
    );
  }

  Widget _titleRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _isIOS
                ? const TextStyle(fontSize: 16)
                : Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(width: 6),
        if (subtitle != null)
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 100),
            child: subtitle!,
          ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return _isIOS
        ? const Divider(height: 1, thickness: 0.3, indent: 16)
        : const Divider(height: 1);
  }
}
