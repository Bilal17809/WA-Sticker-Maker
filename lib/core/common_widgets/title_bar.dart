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
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    useBackButton
                        ? IconActionButton(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              final navigator = Navigator.of(context);
                              Future.delayed(
                                const Duration(milliseconds: 180),
                                () {
                                  if (onBackTap != null) {
                                    onBackTap!();
                                  } else {
                                    navigator.pop();
                                  }
                                },
                              );
                            },
                            icon: Icons.arrow_back_ios_new,
                            size: smallIcon(context),
                          )
                        : IconActionButton(
                            onTap: () => Scaffold.of(context).openDrawer(),
                            icon: Icons.menu,
                            size: secondaryIcon(context),
                          ),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: actions ?? [],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  title,
                  style: titleLargeStyle,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (bottom != null) ...[const SizedBox(height: kElementGap), bottom!],
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
