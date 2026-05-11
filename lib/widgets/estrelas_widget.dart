import 'package:flutter/material.dart';

// Widget para exibir as estrelas de habilidade do jogador, com opção de ser interativo para alterar o valor
class EstrelasWidget extends StatelessWidget {
  final int valor;

  final bool interativo;

  final Function(int)? onAlterar;

  const EstrelasWidget({
    super.key,
    required this.valor,
    this.interativo = false,
    this.onAlterar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,

      children: List.generate(5, (i) {
        return IconButton(
          icon: Icon(
            i < valor ? Icons.star : Icons.star_border,

            color: Colors.amber,
          ),

          onPressed: interativo ? () => onAlterar!(i + 1) : null,
        );
      }),
    );
  }
}
