import 'package:flutter/material.dart';
import 'src/app.dart';
import 'temas/app_temas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _modoTema = ThemeMode.light;

  void _alternarTema() {
    setState(() {
      _modoTema = _modoTema == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Conversor de Monedas',
      theme: AppTemas.modoClaro,
      darkTheme: AppTemas.modoOscuro,
      themeMode: _modoTema,
      home: Aplicacion(alternarTema: _alternarTema),
    );
  }
}