import 'package:flutter/material.dart';

import '../controllers/home_controller.dart';
import '../models/jogador.dart';
import 'jogador_tile.dart';

// Widget para exibir um card de um time, mostrando o número do time, a força total e a lista de jogadores
class TimeCard extends StatelessWidget {
  final int index;

  final List<Jogador> time;

  final HomeController controller;

  const TimeCard({
    super.key,
    required this.index,
    required this.time,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(
          "Time ${index + 1} "
          "(Força: ${controller.somaTime(time)})",
        ),

        children: time.map((j) => JogadorTile(jogador: j)).toList(),
      ),
    );
  }
}
