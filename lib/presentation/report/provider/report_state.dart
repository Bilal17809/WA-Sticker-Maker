class ReportState {
  final String? selectedError;
  final List<String> errors;

  const ReportState({
    this.selectedError,
    this.errors = const [
      "App Crashing",
      "Ads Not Working",
      "Content Issue",
      "Slow Performance",
      "UI Glitching",
      "App Freezing",
      "Wrong Answer/Misinformation",
      "Audio Not Working",
      "Payment/Subscription Issue",
      "Other",
    ],
  });

  ReportState copyWith({String? selectedError, List<String>? errors}) {
    return ReportState(
      selectedError: selectedError ?? this.selectedError,
      errors: errors ?? this.errors,
    );
  }
}
