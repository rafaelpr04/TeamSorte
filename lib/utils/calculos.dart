import 'dart:math';

import '../models/jogador.dart';

// Função para calcular o desvio padrão dos times, usada para medir o balanceamento
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
