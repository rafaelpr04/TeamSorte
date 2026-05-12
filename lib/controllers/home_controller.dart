import '../models/jogador.dart';
import '../services/balanceador_service.dart';

// Controlador principal do aplicativo, responsável por gerenciar os jogadores, gerar os times e calcular o balanceamento
class HomeController {
  List<Jogador> jogadores = [];

  List<List<Jogador>> times = [];

  List<Jogador> banco = [];

  double balanceamento = 0;

  void adicionarJogador({required String nome, required int nivel}) {
    jogadores.add(
      Jogador(
        id: '${DateTime.now().millisecondsSinceEpoch}',
        nome: nome,
        nivel: nivel,
      ),
    );
  }

  void gerarTimes(int jogadoresPorTime) {
    final resultado = BalanceadorService.gerarTimes(
      jogadores: jogadores,
      jogadoresPorTime: jogadoresPorTime,
    );

    times = resultado["times"];

    banco = resultado["banco"];

    balanceamento = resultado["balanceamento"];
  }

  int somaTime(List<Jogador> time) {
    return time.fold(0, (soma, jogador) => soma + jogador.nivel);
  }
}
