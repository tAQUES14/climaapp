import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const ClimaNovaApp());
}

class ClimaNovaApp extends StatelessWidget {
  const ClimaNovaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Previsão do Tempo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.grey.shade200,
      ),
      home: const TelaInicial(),
    );
  }
}

class TelaInicial extends StatefulWidget {
  const TelaInicial({Key? key}) : super(key: key);

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  final TextEditingController _cidadeController = TextEditingController();
  String? _resultadoClima;
  bool _carregando = false;

  Future<void> obterClima(String cidade) async {
    setState(() {
      _carregando = true;
      _resultadoClima = null;
    });

    final chaveApi = '44872268e44f95e96e7da9f4f30236ec';
    final endereco = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$cidade&appid=$chaveApi&units=metric&lang=pt_br',
    );

    try {
      final resposta = await http.get(endereco);

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);
        final temperatura = dados['main']['temp'];
        final condicao = dados['weather'][0]['description'];
        final nomeCidade = dados['name'];

        setState(() {
          _resultadoClima =
              'Local: $nomeCidade\nTemperatura: ${temperatura.toString()}°C\nCondição: ${condicao[0].toUpperCase()}${condicao.substring(1)}';
        });
      } else {
        setState(() {
          _resultadoClima = 'Cidade não encontrada. Verifique o nome.';
        });
      }
    } catch (e) {
      setState(() {
        _resultadoClima = 'Erro ao obter dados do clima.';
      });
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta Meteorológica'),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            TextField(
              controller: _cidadeController,
              decoration: InputDecoration(
                labelText: 'Digite a cidade',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.location_city),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text(
                'Pesquisar',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                final cidade = _cidadeController.text.trim();
                if (cidade.isNotEmpty) {
                  FocusScope.of(context).unfocus();
                  obterClima(cidade);
                }
              },
            ),
            const SizedBox(height: 40),
            if (_carregando)
              const CircularProgressIndicator(color: Colors.deepOrange),
            if (!_carregando && _resultadoClima != null)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.deepOrange.shade100,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepOrange.shade200.withOpacity(0.5),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Text(
                  _resultadoClima!,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
