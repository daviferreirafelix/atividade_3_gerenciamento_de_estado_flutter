import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora Flutter',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _entrada = "";
  String _operador = "";
  double? _num1;
  double? _num2;
  String _resultado = "0";
  String _expressao = "";

  void _limpar() {
    setState(() {
      _entrada = "";
      _operador = "";
      _num1 = null;
      _num2 = null;
      _resultado = "0";
      _expressao = "";
    });
  }

  void _adicionarEntrada(String valor) {
    setState(() {
      _entrada += valor;
      _resultado = _entrada;
      _atualizarExpressao();
    });
  }

  void _escolherOperador(String operador) {
    if (_entrada.isEmpty) return;
    setState(() {
      _num1 = double.tryParse(_entrada);
      _operador = operador;
      _expressao = "$_entrada $_operador ";
      _entrada = "";
    });
  }

  void _calcularResultado() {
    if (_num1 == null || _entrada.isEmpty || _operador.isEmpty) return;

    _num2 = double.tryParse(_entrada);
    if (_num2 == null) return;

    double resultadoTemp;
    switch (_operador) {
      case '+':
        resultadoTemp = _num1! + _num2!;
        break;
      case '-':
        resultadoTemp = _num1! - _num2!;
        break;
      case '×':
        resultadoTemp = _num1! * _num2!;
        break;
      case '÷':
        resultadoTemp = _num2 != 0 ? _num1! / _num2! : double.nan;
        break;
      default:
        return;
    }

    setState(() {
      _resultado = resultadoTemp.toString();
      _expressao = "${_num1!} $_operador ${_num2!} = $_resultado";
      _entrada = "";
      _operador = "";
      _num1 = null;
      _num2 = null;
    });
  }

  void _atualizarExpressao() {
    if (_num1 != null && _operador.isNotEmpty) {
      _expressao = "${_num1!} $_operador $_entrada";
    } else {
      _expressao = _entrada;
    }
  }

  Widget _buildButton(String text,
      {Color? color, void Function()? onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.grey[850],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(20),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculadora"),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            children: [
              // Visor (expressão + resultado)
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _expressao,
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.grey[400],
                        ),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _resultado,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ),

              // Grid de botões
              Expanded(
                flex: 5,
                child: GridView.count(
                  crossAxisCount: isWide ? 4 : 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  padding: const EdgeInsets.all(10),
                  children: [
                    _buildButton("7", onPressed: () => _adicionarEntrada("7")),
                    _buildButton("8", onPressed: () => _adicionarEntrada("8")),
                    _buildButton("9", onPressed: () => _adicionarEntrada("9")),
                    _buildButton("÷",
                        color: Colors.orange,
                        onPressed: () => _escolherOperador("÷")),

                    _buildButton("4", onPressed: () => _adicionarEntrada("4")),
                    _buildButton("5", onPressed: () => _adicionarEntrada("5")),
                    _buildButton("6", onPressed: () => _adicionarEntrada("6")),
                    _buildButton("×",
                        color: Colors.orange,
                        onPressed: () => _escolherOperador("×")),

                    _buildButton("1", onPressed: () => _adicionarEntrada("1")),
                    _buildButton("2", onPressed: () => _adicionarEntrada("2")),
                    _buildButton("3", onPressed: () => _adicionarEntrada("3")),
                    _buildButton("-",
                        color: Colors.orange,
                        onPressed: () => _escolherOperador("-")),

                    _buildButton("C", color: Colors.red, onPressed: _limpar),
                    _buildButton("0", onPressed: () => _adicionarEntrada("0")),
                    _buildButton("=",
                        color: Colors.green, onPressed: _calcularResultado),
                    _buildButton("+",
                        color: Colors.orange,
                        onPressed: () => _escolherOperador("+")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
