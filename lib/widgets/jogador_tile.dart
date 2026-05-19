import 'package:flutter/material.dart';

import '../models/jogador.dart';
import 'estrelas_widget.dart';

class JogadorTile extends StatelessWidget {
  final Jogador jogador;
  final VoidCallback? onRemover;
  final VoidCallback? onEditar; // <-- NOVO

  const JogadorTile({
    super.key,
    required this.jogador,
    this.onRemover,
    this.onEditar, // <-- NOVO
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: Text(jogador.nome),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          EstrelasWidget(valor: jogador.nivel),
          if (onEditar != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.blue),
              tooltip: 'Editar jogador',
              onPressed: onEditar,
            ),
          if (onRemover != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              tooltip: 'Remover jogador',
              onPressed: onRemover,
            ),
        ],
      ),
    );
  }
}
