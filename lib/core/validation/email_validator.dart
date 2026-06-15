bool isValidEmail(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return false;
  }

  return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(trimmed);
}
