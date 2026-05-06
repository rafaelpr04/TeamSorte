import 'dart:math';
import 'package:flutter/material.dart';
import 'models/jogador.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balanceador de Times',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Jogador> jogadores = [];
  final TextEditingController nomeController = TextEditingController();

  int estrelas = 3;
  int jogadoresPorTime = 5;

  List<List<Jogador>> times = [];
  List<Jogador> banco = [];
  double balanceamento = 0;

  void adicionarJogador() {
    if (nomeController.text.isEmpty) return;

    setState(() {
      jogadores.add(Jogador(nomeController.text, estrelas));
      nomeController.clear();
      estrelas = 3;
    });
  }

  void gerarTimes() {
    if (jogadores.length < jogadoresPorTime * 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Jogadores insuficientes para formar ao menos 2 times"),
        ),
      );
      return;
    }

    List<Jogador> lista = List.from(jogadores);
    lista.shuffle(Random());

    int nTimes = lista.length ~/ jogadoresPorTime;
    int nBanco = lista.length % jogadoresPorTime;

    banco = lista.sublist(0, nBanco);
    List<Jogador> participantes = lista.sublist(nBanco);

    participantes.sort((a, b) => b.nivel.compareTo(a.nivel));

    times = List.generate(nTimes, (_) => []);

    distribuirZigZag(participantes, times);

    double desvio = calcularDesvioPadraoTimes(times);
    balanceamento = desvio == 0 ? 100 : 100 / (1 + desvio);

    setState(() {});
  }

  int somaTime(List<Jogador> time) {
    return time.fold(0, (soma, j) => soma + j.nivel);
  }

  Widget estrelasWidget(int valor, {bool interativo = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return IconButton(
          icon: Icon(
            i < valor ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: interativo
              ? () {
                  setState(() {
                    estrelas = i + 1;
                  });
                }
              : null,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Balanceador de Times"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // CARD INPUT
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: nomeController,
                      decoration: const InputDecoration(
                        labelText: "Nome do jogador",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),

                    estrelasWidget(estrelas, interativo: true),

                    const SizedBox(height: 10),

                    // NOVO STEPPER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Jogadores por time",
                          style: TextStyle(fontSize: 16),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                if (jogadoresPorTime > 2) {
                                  setState(() {
                                    jogadoresPorTime--;
                                  });
                                }
                              },
                            ),
                            Text(
                              "$jogadoresPorTime",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () {
                                setState(() {
                                  jogadoresPorTime++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton.icon(
                      onPressed: adicionarJogador,
                      icon: const Icon(Icons.person_add),
                      label: const Text("Adicionar jogador"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(45),
                      ),
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton.icon(
                      onPressed: gerarTimes,
                      icon: const Icon(Icons.shuffle),
                      label: const Text("Gerar / Rebalancear Times"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(45),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                children: [
                  const Text(
                    "Jogadores",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  ...jogadores.map(
                    (j) => ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(j.nome),
                      trailing: estrelasWidget(j.nivel),
                    ),
                  ),

                  const SizedBox(height: 10),

                  if (times.isNotEmpty) ...[
                    Text(
                      "Balanceamento: ${balanceamento.toStringAsFixed(1)}%",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    ...times.asMap().entries.map((entry) {
                      int i = entry.key;
                      var time = entry.value;

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.indigo.shade50,
                        child: ExpansionTile(
                          title: Text(
                            "Time ${i + 1} (Força: ${somaTime(time)})",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          children: time
                              .map(
                                (j) => ListTile(
                                  title: Text(j.nome),
                                  trailing: estrelasWidget(j.nivel),
                                ),
                              )
                              .toList(),
                        ),
                      );
                    }),

                    if (banco.isNotEmpty)
                      Card(
                        color: Colors.grey.shade200,
                        child: ExpansionTile(
                          title: const Text("Banco"),
                          children: banco
                              .map(
                                (j) => ListTile(
                                  title: Text(j.nome),
                                  trailing: estrelasWidget(j.nivel),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//--------------------------------------------

void distribuirZigZag(List<Jogador> participantes, List<List<Jogador>> times) {
  int nTimes = times.length;

  int indexTime = 0;
  bool indo = true;

  for (var jogador in participantes) {
    times[indexTime].add(jogador);

    if (indo) {
      indexTime++;
      if (indexTime == nTimes) {
        indexTime = nTimes - 1;
        indo = false;
      }
    } else {
      indexTime--;
      if (indexTime < 0) {
        indexTime = 0;
        indo = true;
      }
    }
  }
}

double calcularDesvioPadraoTimes(List<List<Jogador>> times) {
  int nTimes = times.length;

  List<int> somaTimes = [];

  for (var time in times) {
    int soma = 0;
    for (var jogador in time) {
      soma += jogador.nivel;
    }
    somaTimes.add(soma);
  }

  double media = somaTimes.reduce((a, b) => a + b) / nTimes;

  double somaQuadrados = 0;

  for (var valor in somaTimes) {
    somaQuadrados += pow(valor - media, 2);
  }

  double variancia = somaQuadrados / nTimes;

  return sqrt(variancia);
}
