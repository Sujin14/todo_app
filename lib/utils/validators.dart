String? emailValidator(String? value) {
  if (value == null || value.trim().isEmpty) return 'Email is required';
  if (!value.contains('@')) return 'Invalid email';
  return null;
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) return 'Password is required';
  if (value.length < 6) return 'Min 6 characters';
  return null;
}

String? confirmPasswordValidator(String? value, String password) {
  if (value == null || value.isEmpty) return 'Confirm your password';
  if (value != password) return 'Passwords do not match';
  return null;
}

String? titleValidator(String? value) {
  if (value == null || value.trim().isEmpty) return 'Title required';
  return null;
}