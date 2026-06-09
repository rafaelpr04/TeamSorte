import 'package:flutter/material.dart';

/// Controlador simples e global do tema (claro/escuro).
///
/// Use [ThemeController.instance.modo] dentro de um [ValueListenableBuilder]
/// para reconstruir a aplicação quando o tema mudar, e
/// [ThemeController.instance.alternar] para trocar entre claro e escuro.
class ThemeController {
  ThemeController._();

  static final ThemeController instance = ThemeController._();

  final ValueNotifier<ThemeMode> modo = ValueNotifier<ThemeMode>(
    ThemeMode.light,
  );

  bool get isEscuro => modo.value == ThemeMode.dark;

  void alternar() {
    modo.value = isEscuro ? ThemeMode.light : ThemeMode.dark;
  }
}
