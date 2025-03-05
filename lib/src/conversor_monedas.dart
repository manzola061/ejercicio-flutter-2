import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConversorMonedas extends StatefulWidget {
  final VoidCallback alternarTema;

  const ConversorMonedas({super.key, required this.alternarTema});

  @override
  State<ConversorMonedas> createState() => _ConversorMonedasEstado();
}

class _ConversorMonedasEstado extends State<ConversorMonedas> {
  final TextEditingController _controladorCantidad = TextEditingController();
  String _resultadoConversion = '';
  
  double tasaUSD = 64.48;
  double tasaEUR = 67.12;
  double tasaCNY = 8.86;
  double tasaTRY = 1.76;
  double tasaRUB = 0.72;

  String _monedaOrigen = 'VES';
  String _monedaDestino = 'USD';
  final List<String> _monedas = ['VES', 'USD', 'EUR', 'CNY', 'TRY', 'RUB'];

  void _convertirMoneda(String valor) {
    double cantidad = double.tryParse(valor) ?? 0;
    if (cantidad < 0) {
      setState(() => _resultadoConversion = 'No se permiten valores negativos');
      return;
    }

    double tasaOrigen = _obtenerTasa(_monedaOrigen);
    double tasaDestino = _obtenerTasa(_monedaDestino);
    double resultado = (cantidad * tasaOrigen) / tasaDestino;

    final formato = NumberFormat.currency(decimalDigits: 2, symbol: '');
    setState(() => _resultadoConversion = '${formato.format(resultado)} $_monedaDestino');
  }

  double _obtenerTasa(String moneda) {
    return switch (moneda) {
      'USD' => tasaUSD,
      'EUR' => tasaEUR,
      'CNY' => tasaCNY,
      'TRY' => tasaTRY,
      'RUB' => tasaRUB,
      _ => 1.0,
    };
  }

  void _mostrarDialogoActualizarTasas() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Actualizar Tasas de Cambio'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _crearCampoTasa('USD', tasaUSD, (valor) => tasaUSD = valor),
            _crearCampoTasa('EUR', tasaEUR, (valor) => tasaEUR = valor),
            _crearCampoTasa('CNY', tasaCNY, (valor) => tasaCNY = valor),
            _crearCampoTasa('TRY', tasaTRY, (valor) => tasaTRY = valor),
            _crearCampoTasa('RUB', tasaRUB, (valor) => tasaRUB = valor),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Widget _crearCampoTasa(String moneda, double tasaInicial, Function(double) onCambio) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextField(
        controller: TextEditingController(text: tasaInicial.toStringAsFixed(2)),
        decoration: InputDecoration(labelText: 'Tasa de $moneda', border: OutlineInputBorder()),
        keyboardType: TextInputType.number,
        onChanged: (valor) {
          double? nuevaTasa = double.tryParse(valor);
          if (nuevaTasa != null) {
            onCambio(nuevaTasa);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversor de Monedas'),
        actions: [
          IconButton(icon: const Icon(Icons.dark_mode), onPressed: widget.alternarTema),
          IconButton(icon: const Icon(Icons.settings), onPressed: _mostrarDialogoActualizarTasas),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: _monedaOrigen,
                  onChanged: (valor) => setState(() {
                    _monedaOrigen = valor!;
                    _convertirMoneda(_controladorCantidad.text);
                  }),
                  items: _monedas.map((moneda) => DropdownMenuItem(value: moneda, child: Text(moneda))).toList(),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _monedaDestino,
                  onChanged: (valor) => setState(() {
                    _monedaDestino = valor!;
                    _convertirMoneda(_controladorCantidad.text);
                  }),
                  items: _monedas.map((moneda) => DropdownMenuItem(value: moneda, child: Text(moneda))).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controladorCantidad,
              decoration: InputDecoration(labelText: 'Ingrese la cantidad', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: _convertirMoneda,
            ),
            const SizedBox(height: 20),
            Text(
              _resultadoConversion,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}