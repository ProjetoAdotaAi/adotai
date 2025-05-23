String? cepValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Informe seu CEP';
  }
  
  if (value.length != 9) {
    return 'CEP inválido';
  }
  return null;
}

String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Informe seu email';
  }
  
  String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  RegExp regExp = RegExp(pattern);

  if (!regExp.hasMatch(value)) {
    return 'Email inválido';
  }

  return null;
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Informe sua senha';
  }

  if (value.length < 6) {
    return 'A senha deve ter no mínimo 6 caracteres';
  }
  
  return null;
}

String? phoneValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Informe seu telefone';
  }

  if (value.length != 15 && value.length != 14) {
    return 'Telefone inválido';
  }

  return null;
}

