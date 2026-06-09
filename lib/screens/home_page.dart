import 'package:flutter/material.dart';
import 'package:teamsort_application/models/jogador.dart';

import '../controllers/home_controller.dart';
import '../controllers/theme_controller.dart';
import '../widgets/estrelas_widget.dart';
import '../widgets/jogador_tile.dart';
import '../widgets/sports_background.dart';
import '../widgets/time_card.dart';
import 'resultado_screen.dart';

// Tela principal do aplicativo, onde o usuário pode adicionar jogadores, configurar o número de jogadores por time e gerar os times balanceados
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController controller = HomeController();

  final TextEditingController nomeController = TextEditingController();

  int estrelas = 3;

  int jogadoresPorTime = 5;

  void adicionarJogador() {
    if (nomeController.text.isEmpty) return;

    setState(() {
      controller.adicionarJogador(nome: nomeController.text, nivel: estrelas);

      nomeController.clear();

      estrelas = 3;
    });
  }

  void gerarTimes() {
    if (controller.jogadores.length < jogadoresPorTime * 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Jogadores insuficientes para formar ao menos 2 times"),
        ),
      );
      return;
    }

    setState(() {
      controller.gerarTimes(jogadoresPorTime);
    });

    // NAVEGA para a tela de resultado
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultadoScreen(controller: controller),
      ),
    );
  }

  void editarJogador(Jogador jogador) {
    final editController = TextEditingController(text: jogador.nome);
    int novoNivel = jogador.nivel;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Editar jogador'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Novo nome',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              EstrelasWidget(
                valor: novoNivel,
                interativo: true,
                onAlterar: (valor) {
                  setStateDialog(() {
                    novoNivel = valor;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final novoNome = editController.text.trim();
                if (novoNome.isNotEmpty) {
                  setState(() {
                    controller.editarJogador(jogador, novoNome, novoNivel);
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      appBar: AppBar(
        title: const Text("Team Sort"),
        centerTitle: true,
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              ThemeController.instance.isEscuro
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            tooltip: ThemeController.instance.isEscuro
                ? 'Modo claro'
                : 'Modo escuro',
            onPressed: ThemeController.instance.alternar,
          ),
        ],
      ),

      body: SportsBackground(
        child: SafeArea(
          top: false,
          child: ResponsiveCenter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
            //-----------------------------------
            // CARD DE INPUT
            //-----------------------------------
            Card(
              elevation: 3,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [
                    //-----------------------------------
                    // INPUT NOME
                    //-----------------------------------
                    TextField(
                      controller: nomeController,

                      decoration: const InputDecoration(
                        labelText: "Nome do jogador",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 10),

                    //-----------------------------------
                    // ESTRELAS
                    //-----------------------------------
                    EstrelasWidget(
                      valor: estrelas,

                      interativo: true,

                      onAlterar: (novoValor) {
                        setState(() {
                          estrelas = novoValor;
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    //-----------------------------------
                    // JOGADORES POR TIME
                    //-----------------------------------
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

                    //-----------------------------------
                    // BOTÃO ADICIONAR
                    //-----------------------------------
                    ElevatedButton.icon(
                      onPressed: adicionarJogador,

                      icon: const Icon(Icons.person_add),

                      label: const Text("Adicionar jogador"),

                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(45),
                      ),
                    ),

                    const SizedBox(height: 10),

                    //-----------------------------------
                    // BOTÃO GERAR TIMES
                    //-----------------------------------
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

            //-----------------------------------
            // LISTA
            //-----------------------------------
            Expanded(
              child: ListView(
                children: [
                  //-----------------------------------
                  // JOGADORES
                  //-----------------------------------
                  const Text(
                    "Jogadores",

                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  ...controller.jogadores.map(
                    (jogador) => JogadorTile(
                      jogador: jogador,
                      onEditar: () => editarJogador(jogador),
                      onRemover: () {
                        setState(() {
                          controller.removerJogador(jogador);
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 15),

                  //-----------------------------------
                  // TIMES
                  //-----------------------------------
                  if (controller.times.isNotEmpty) ...[
                    Text(
                      "Balanceamento: "
                      "${controller.balanceamento.toStringAsFixed(1)}%",

                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    ...controller.times.asMap().entries.map((entry) {
                      return TimeCard(
                        index: entry.key,

                        time: entry.value,

                        controller: controller,
                      );
                    }),

                    //-----------------------------------
                    // BANCO
                    //-----------------------------------
                    if (controller.banco.isNotEmpty)
                      Card(
                        child: ExpansionTile(
                          title: const Text("Banco"),

                          children: controller.banco
                              .map((jogador) => JogadorTile(jogador: jogador))
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
          ),
        ),
      ),
    );
  }
}
