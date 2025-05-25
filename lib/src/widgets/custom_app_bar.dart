import 'package:flutter/material.dart';
import '../utils/theme.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.appTitle,
    this.route,
    this.icon,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  final String? appTitle;
  final String? route;
  final Widget? icon;
  final List<Widget>? actions;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      title: Text(
        widget.appTitle ?? '',
        style: TextStyle(
          fontSize: 20,
          color: colorScheme.primary, // ✅ dynamic text color
        ),
      ),
      leading: widget.icon != null
          ? Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: CustomTheme.primaryGradient,
        ),
        child: IconButton(
          onPressed: () {
            if (widget.route != null) {
              Navigator.of(context).pushNamed(widget.route!);
            } else {
              Navigator.of(context).pop();
            }
          },
          icon: widget.icon!,
          iconSize: 16,
          color: Colors.white,
        ),
      )
          : null,
      actions: widget.actions,
    );
  }
}
