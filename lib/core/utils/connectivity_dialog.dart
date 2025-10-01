import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '/core/common_widgets/common_widgets.dart';
import '/core/services/services.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';

class ConnectivityDialog {
  static Future<void> showNoInternetDialog(
    BuildContext context, {
    required Future<void> Function() onRetry,
  }) {
    final RxBool isConnected = ConnectivityService.instance.isConnectedRx;
    return AppAlertDialog.show(
      context: context,
      barrierDismissible: false,
      title: "No Internet",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Please check your internet connection and try again."),
          const SizedBox(height: kBodyHp),
          Obx(
            () => Row(
              children: [
                Icon(
                  isConnected.value ? Icons.wifi : Icons.wifi_off,
                  color: isConnected.value ? AppColors.kGreen : AppColors.kRed,
                ),
                const Gap(kGap),
                Text(
                  isConnected.value ? "Connected" : "Disconnected",
                  style: TextStyle(
                    color:
                        isConnected.value ? AppColors.kGreen : AppColors.kRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        Obx(
          () => ElevatedButton(
            onPressed:
                isConnected.value
                    ? () async {
                      Navigator.of(context).pop();
                      await onRetry();
                    }
                    : null,
            child: const Text("Retry"),
          ),
        ),
      ],
    );
  }
}
