import 'package:flutter/material.dart';
import 'conversor_monedas.dart';

class Aplicacion extends StatelessWidget {
  final VoidCallback alternarTema;

  const Aplicacion({super.key, required this.alternarTema});

  @override
  Widget build(BuildContext context) {
    return ConversorMonedas(alternarTema: alternarTema);
  }
}