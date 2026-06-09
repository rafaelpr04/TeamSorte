import 'package:flutter/material.dart';

import '../controllers/cronometro_controller.dart';
import '../widgets/sports_background.dart';

class CronometroScreen extends StatefulWidget {
  const CronometroScreen({super.key});

  @override
  State<CronometroScreen> createState() => _CronometroScreenState();
}

class _CronometroScreenState extends State<CronometroScreen> {
  late final CronometroController controller;

  @override
  void initState() {
    super.initState();
    controller = CronometroController(onTick: () => setState(() {}));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _buildDropdown(
    String label,
    int value,
    int max,
    ValueChanged<int?> onChanged,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: DropdownButton<int>(
                value: value,
                isExpanded: true,
                underline: const SizedBox.shrink(),
                onChanged: onChanged,
                items: List.generate(max + 1, (index) => index)
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(item.toString().padLeft(2, '0')),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canStart =
        !controller.isRunning && controller.remaining.inSeconds > 0;
    final canPause = controller.isRunning;
    final canResume = controller.isPaused && controller.remaining.inSeconds > 0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Cronômetro'),
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF4F46E5),
      ),
      body: SportsBackground(
        child: SafeArea(
          top: false,
          child: ResponsiveCenter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Tempo selecionado',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildDropdown('Horas', controller.horas, 23, (value) {
                          if (value == null) return;
                          controller.updateHours(value);
                        }),
                        const SizedBox(width: 8),
                        _buildDropdown('Minutos', controller.minutos, 59, (
                          value,
                        ) {
                          if (value == null) return;
                          controller.updateMinutes(value);
                        }),
                        const SizedBox(width: 8),
                        _buildDropdown('Segundos', controller.segundos, 59, (
                          value,
                        ) {
                          if (value == null) return;
                          controller.updateSeconds(value);
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.formattedTime,
                    style: const TextStyle(
                      fontSize: 54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    controller.remaining.inSeconds == 0
                        ? 'Tempo finalizado'
                        : (controller.isRunning
                              ? 'Cronômetro em andamento'
                              : (controller.isPaused
                                    ? 'Pausado'
                                    : 'Pronto para iniciar')),
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: canStart
                      ? controller.start
                      : (canResume ? controller.pauseOrResume : null),
                  icon: Icon(
                    canResume ? Icons.play_arrow : Icons.play_circle_fill,
                  ),
                  label: Text(canResume ? 'Retomar' : 'Iniciar'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: canPause ? controller.pauseOrResume : null,
                  icon: const Icon(Icons.pause_circle_filled),
                  label: const Text('Pausar'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Colors.orange,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: controller.finish,
                  icon: const Icon(Icons.stop_circle),
                  label: const Text('Encerrar'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Colors.red,
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: controller.reset,
                  icon: const Icon(Icons.restore),
                  label: const Text('Zerar'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
              ],
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
