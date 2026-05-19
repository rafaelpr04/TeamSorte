import 'dart:async';

import 'package:flutter/foundation.dart';

import '../services/cronometro_service.dart';

class CronometroController {
  int horas;
  int minutos;
  int segundos;

  Duration _initialDuration;
  Duration _remaining;
  Timer? _timer;
  bool isPaused = false;

  final VoidCallback onTick;

  CronometroController({
    required this.onTick,
    this.horas = 0,
    this.minutos = 1,
    this.segundos = 0,
  }) : _initialDuration = Duration(
         hours: horas,
         minutes: minutos,
         seconds: segundos,
       ),
       _remaining = Duration(hours: horas, minutes: minutos, seconds: segundos);

  Duration get remaining => _remaining;

  String get formattedTime => CronometroService.formatDuration(_remaining);

  bool get isRunning => _timer?.isActive == true && !isPaused;

  void _updateInitialDuration() {
    _initialDuration = Duration(
      hours: horas,
      minutes: minutos,
      seconds: segundos,
    );
    if (!isRunning) {
      _remaining = _initialDuration;
    }
  }

  void updateHours(int value) {
    horas = value;
    _updateInitialDuration();
    onTick();
  }

  void updateMinutes(int value) {
    minutos = value;
    _updateInitialDuration();
    onTick();
  }

  void updateSeconds(int value) {
    segundos = value;
    _updateInitialDuration();
    onTick();
  }

  void start() {
    if (_remaining.inSeconds <= 0) return;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), _handleTick);
    isPaused = false;
    onTick();
  }

  void _handleTick(Timer timer) {
    if (_remaining.inSeconds <= 1) {
      finish();
      return;
    }

    _remaining -= const Duration(seconds: 1);
    onTick();
  }

  void pauseOrResume() {
    if (isRunning) {
      _timer?.cancel();
      isPaused = true;
      onTick();
      return;
    }

    if (isPaused && _remaining.inSeconds > 0) {
      start();
    }
  }

  void finish() {
    _timer?.cancel();
    _remaining = Duration.zero;
    isPaused = false;
    onTick();
  }

  void reset() {
    _timer?.cancel();
    _remaining = _initialDuration;
    isPaused = false;
    onTick();
  }

  void dispose() {
    _timer?.cancel();
  }
}
