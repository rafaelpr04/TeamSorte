import 'package:flutter/material.dart';

import '../models/jogador.dart';
import 'estrelas_widget.dart';

// Widget para exibir as informações de um jogador em uma lista, mostrando o nome e as estrelas de habilidade
class JogadorTile extends StatelessWidget {
  final Jogador jogador;

  const JogadorTile({super.key, required this.jogador});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person),

      title: Text(jogador.nome),

      trailing: EstrelasWidget(valor: jogador.nivel),
    );
  }
}
