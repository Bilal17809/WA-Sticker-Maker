import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '/core/common_widgets/common_widgets.dart';
import 'report_state.dart';

class ReportNotifier extends Notifier<ReportState> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final String reportEmail = "unisoftaps@gmail.com";
  @override
  ReportState build() => const ReportState();

  void setSelectedError(String? value) {
    state = state.copyWith(selectedError: value);
  }

  Future<void> sendReport(BuildContext context) async {
    if (nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        state.selectedError == null) {
      SimpleToast.showToast(
        context: context,
        message: "Please fill all fields before submitting",
      );
      return;
    }
    final subject = "Bug Report for WA Sticker Maker: ${state.selectedError}";
    final body =
        "Name: ${nameController.text}\n\nError: ${state.selectedError}\n\nDescription:\n${descriptionController.text}";
    final emailUri = Uri.parse(
      "mailto:$reportEmail?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}",
    );
    try {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (context.mounted) {
        SimpleToast.showToast(
          context: context,
          message: "Could not launch email app",
        );
      }
    }
  }
}
