String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'El email es requerido';
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Ingresa un email válido';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'La contraseña es requerida';
  }
  if (value.length < 6) {
    return 'La contraseña debe tener al menos 6 caracteres';
  }
  return null;
}