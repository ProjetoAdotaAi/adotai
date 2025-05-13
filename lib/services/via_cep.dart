import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/snackbar.dart';

Future<void> consultarCep(
  BuildContext context,
  String cep,
  dynamic estadoController,
  dynamic cidadeController,
) async {
  final String url = 'https://viacep.com.br/ws/$cep/json/';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);

    if (data['erro'] == null) {
      cidadeController.text = data['localidade'];
      estadoController.text = data['uf'];
    } else {
      SnackBarUtil.showWarning(context, 'CEP inválido');
    }
  } else {
    SnackBarUtil.showError(context, 'Falha ao consultar o CEP');
  }
}
