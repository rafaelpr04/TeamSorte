import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import '../screens/cronometro_screen.dart';
import '../widgets/jogador_tile.dart';

class ResultadoScreen extends StatelessWidget {
  final HomeController controller;

  const ResultadoScreen({super.key, required this.controller});

  static const List<Color> coresTimes = [
    Color(0xFF4F46E5),
    Color(0xFF7C3AED),
    Color(0xFF0E7490),
    Color(0xFF065F46),
    Color(0xFF9D174D),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        title: const Text('Resultado'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.timer),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CronometroScreen()),
              );
            },
            tooltip: 'Cronômetro',
          ),
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
            tooltip: 'Voltar',
          ),
        ],
      ),
      body: Column(
        children: [
          // BARRA DE BALANCEAMENTO
          Container(
            color: const Color(0xFFEEF2FF),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.bar_chart, color: Color(0xFF4F46E5), size: 20),
                const SizedBox(width: 8),
                Text(
                  'Balanceamento: ${controller.balanceamento.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: Color(0xFF4F46E5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: controller.balanceamento / 100,
                      backgroundColor: const Color(0xFFC7D2FE),
                      color: const Color(0xFF4F46E5),
                      minHeight: 6,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // LISTA DE TIMES
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...controller.times.asMap().entries.map((entry) {
                  final cor = coresTimes[entry.key % coresTimes.length];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        // HEADER DO TIME
                        Container(
                          color: cor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white24,
                                radius: 14,
                                child: Text(
                                  '${entry.key + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Time ${entry.key + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'Força: ${controller.somaTime(entry.value)}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // JOGADORES DO TIME
                        ...entry.value.map((j) => JogadorTile(jogador: j)),
                      ],
                    ),
                  );
                }),

                // BANCO
                if (controller.banco.isNotEmpty)
                  Card(
                    color: Colors.grey.shade200,
                    child: ExpansionTile(
                      leading: const Icon(Icons.event_seat),
                      title: const Text('Banco'),
                      children: controller.banco
                          .map((j) => JogadorTile(jogador: j))
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
