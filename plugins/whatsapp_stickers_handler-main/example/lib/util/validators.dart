/// Form validators
class Validators {
  /// Checks if input has value
  static String? required(String? input) {
    final String error = 'Required';
    return input == null || input.isEmpty ? error : null;
  }
}
