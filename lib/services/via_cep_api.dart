import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> consultarCep({
  required String cep,
  required TextEditingController cidadeController,
  required TextEditingController estadoController,
  required BuildContext context,
}) async {
  final url = 'https://viacep.com.br/ws/$cep/json/';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);

    if (data['erro'] == null) {
      cidadeController.text = data['localidade'];
      estadoController.text = data['uf'];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CEP inválido')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Falha ao consultar o CEP')),
    );
  }
}
