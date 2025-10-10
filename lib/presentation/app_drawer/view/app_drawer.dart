import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/presentation/premium_screen/premium_screen.dart';
import '/core/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';
import '/core/utils/utils.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Container(
        color: AppColors.getBgColor(context),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: AppDecorations.gradientDecor(
                context,
              ).copyWith(borderRadius: BorderRadius.zero),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: kElementGap),
                      child: Image.asset(
                        Assets.appIcon,
                        height: primaryIcon(context),
                      ),
                    ),
                  ),
                  const Gap(kGap),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'WA Sticker Maker',
                      style: titleLargeStyle.copyWith(color: AppColors.kWhite),
                    ),
                  ),
                ],
              ),
            ),
            _DrawerTile(
              icon: Icons.star_rounded,
              title: 'Rate Us',
              onTap: () {
                DrawerActions.rateUs();
              },
            ),
            Divider(color: AppColors.primaryColorLight.withValues(alpha: 0.1)),
            _DrawerTile(
              icon: Icons.more,
              title: 'More Apps',
              onTap: () {
                DrawerActions.moreApp();
              },
            ),
            Divider(color: AppColors.primaryColorLight.withValues(alpha: 0.1)),
            _DrawerTile(
              icon: Icons.privacy_tip_rounded,
              title: 'Privacy Policy',
              onTap: () {
                DrawerActions.privacy();
              },
            ),
            Divider(color: AppColors.primaryColorLight.withValues(alpha: 0.1)),
            if (Platform.isIOS) ...[
              _DrawerTile(
                icon: Icons.star_rounded,
                title: 'Remove Ads',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PremiumScreen()),
                  );
                },
              ),
              Divider(
                color: AppColors.primaryColorLight.withValues(alpha: 0.1),
              ),
            ],
            // if (Platform.isAndroid) ...[
            //   _DrawerTile(
            //     icon: Icons.report,
            //     title: 'Report An Issue',
            //     onTap: () => Get.to(() => ReportView()),
            //   ),
            //   Divider(
            //     color: AppColors.primaryColorLight.withValues(alpha: 0.1),
            //   ),
            // ],
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 24, color: AppColors.primaryText(context)),
      title: Text(title, style: titleSmallStyle),
      onTap: onTap,
    );
  }
}
