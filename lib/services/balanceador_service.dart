import 'dart:math';

import '../models/jogador.dart';
import '../utils/calculos.dart';

// Classe responsável por balancear os times com base nos jogadores e suas habilidades
class BalanceadorService {
  static Map<String, dynamic> gerarTimes({
    required List<Jogador> jogadores,
    required int jogadoresPorTime,
  }) {
    List<Jogador> lista = List.from(jogadores);

    lista.shuffle(Random());

    int nTimes = lista.length ~/ jogadoresPorTime;
    int nBanco = lista.length % jogadoresPorTime;

    List<Jogador> banco = lista.sublist(0, nBanco);

    List<Jogador> participantes = lista.sublist(nBanco);

    participantes.sort((a, b) => b.nivel.compareTo(a.nivel));

    List<List<Jogador>> times = List.generate(nTimes, (_) => []);

    _distribuirZigZag(participantes, times);

    double desvio = calcularDesvioPadraoTimes(times);

    double balanceamento = desvio == 0 ? 100 : 100 / (1 + desvio);

    return {"times": times, "banco": banco, "balanceamento": balanceamento};
  }

  static void _distribuirZigZag(
    List<Jogador> participantes,
    List<List<Jogador>> times,
  ) {
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
}
