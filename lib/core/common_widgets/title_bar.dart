import 'package:flutter/material.dart';
import '/core/theme/theme.dart';
import 'buttons.dart';
import '/core/constants/constants.dart';

class TitleBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final String title;
  final bool useBackButton;
  final VoidCallback? onBackTap;
  final PreferredSizeWidget? bottom;

  const TitleBar({
    super.key,
    required this.title,
    this.useBackButton = true,
    this.actions,
    this.onBackTap,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          title,
          style: titleLargeStyle.copyWith(color: AppColors.kWhite),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      leading: useBackButton
          ? IconActionButton(
              onTap: () {
                FocusScope.of(context).unfocus();
                final navigator = Navigator.of(context);
                Future.delayed(const Duration(milliseconds: 180), () {
                  if (onBackTap != null) {
                    onBackTap!();
                  } else {
                    navigator.pop();
                  }
                });
              },
              icon: Icons.arrow_back_ios_new,
              color: AppColors.kWhite,
              size: smallIcon(context),
            )
          : IconActionButton(
              onTap: () => Scaffold.of(context).openDrawer(),
              icon: Icons.menu,
              color: AppColors.kWhite,
              size: secondaryIcon(context),
            ),
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
