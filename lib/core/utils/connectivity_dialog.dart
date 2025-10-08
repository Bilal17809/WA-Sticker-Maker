import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/services/connectivity_service.dart';
import '/core/common_widgets/common_widgets.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';
import 'package:gap/gap.dart';

class ConnectivityDialog {
  static bool _isDialogOpen = false;

  static Future<void> showNoInternetDialog(
    BuildContext context, {
    required Future<void> Function() onRetry,
  }) async {
    if (_isDialogOpen) return;
    _isDialogOpen = true;

    await AppAlertDialog.show(
      context: context,
      barrierDismissible: false,
      title: "No Internet",
      content: Consumer(
        builder: (context, ref, _) {
          final asyncStatus = ref.watch(internetStatusStreamProvider);
          final isConnected = asyncStatus.maybeWhen(
            data: (v) => v,
            orElse: () => false,
          );
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Please check your internet connection and try again.",
              ),
              const SizedBox(height: kBodyHp),
              Row(
                children: [
                  Icon(
                    isConnected ? Icons.wifi : Icons.wifi_off,
                    color: isConnected ? AppColors.kGreen : AppColors.kRed,
                  ),
                  const Gap(kGap),
                  Text(
                    isConnected ? "Connected" : "Disconnected",
                    style: TextStyle(
                      color: isConnected ? AppColors.kGreen : AppColors.kRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      actions: [
        AppDialogButton(
          text: "Cancel",
          onPressed: () => Navigator.of(context).pop(),
        ),
        Consumer(
          builder: (context, ref, _) {
            final asyncStatus = ref.watch(internetStatusStreamProvider);
            final isConnected = asyncStatus.maybeWhen(
              data: (v) => v,
              orElse: () => false,
            );
            return ElevatedButton(
              onPressed: isConnected
                  ? () async {
                      Navigator.of(context).pop();
                      await onRetry();
                    }
                  : null,
              child: const Text("Retry"),
            );
          },
        ),
      ],
    ).whenComplete(() {
      _isDialogOpen = false;
    });
  }

  static void closeIfOpen(BuildContext context) {
    if (_isDialogOpen && Navigator.canPop(context)) {
      Navigator.of(context).pop();
      _isDialogOpen = false;
    }
  }
}
