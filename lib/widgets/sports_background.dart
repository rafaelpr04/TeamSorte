import 'package:flutter/material.dart';

/// Fundo decorativo esportivo, com um gradiente suave e ícones de bolas de
/// futebol e basquete espalhados de forma sutil.
///
/// Informe [escuro] para forçar o fundo escuro (ex.: splash). Quando deixado em
/// `null`, o fundo acompanha automaticamente o brilho do tema atual, ficando
/// escuro no dark mode e claro no light mode.
class SportsBackground extends StatelessWidget {
  final Widget child;
  final bool? escuro;

  const SportsBackground({super.key, required this.child, this.escuro});

  // Posições relativas (fração da largura/altura) e características de cada bola.
  static const List<_Bola> _bolas = [
    _Bola(dx: -0.06, dy: 0.04, size: 120, futebol: true, angulo: 0.2),
    _Bola(dx: 0.82, dy: 0.10, size: 150, futebol: false, angulo: -0.3),
    _Bola(dx: -0.10, dy: 0.42, size: 160, futebol: false, angulo: 0.1),
    _Bola(dx: 0.78, dy: 0.62, size: 130, futebol: true, angulo: 0.4),
    _Bola(dx: 0.10, dy: 0.86, size: 90, futebol: false, angulo: -0.2),
    _Bola(dx: 0.62, dy: 0.92, size: 110, futebol: true, angulo: 0.25),
    _Bola(dx: 0.38, dy: 0.30, size: 70, futebol: true, angulo: 0.0),
  ];

  @override
  Widget build(BuildContext context) {
    final escuro =
        this.escuro ?? Theme.of(context).brightness == Brightness.dark;
    final corFutebol = escuro
        ? Colors.white.withOpacity(0.07)
        : const Color(0xFF4F46E5).withOpacity(0.07);
    final corBasquete = const Color(0xFFEA580C).withOpacity(escuro ? 0.14 : 0.10);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: escuro
              ? const [Color(0xFF1E1B4B), Color(0xFF312E81), Color(0xFF1E1B4B)]
              : const [Color(0xFFEEF2FF), Color(0xFFF5F3FF), Color(0xFFEEF2FF)],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          return Stack(
            children: [
              for (final bola in _bolas)
                Positioned(
                  left: bola.dx * w,
                  top: bola.dy * h,
                  child: Transform.rotate(
                    angle: bola.angulo,
                    child: Icon(
                      bola.futebol
                          ? Icons.sports_soccer
                          : Icons.sports_basketball,
                      size: bola.size,
                      color: bola.futebol ? corFutebol : corBasquete,
                    ),
                  ),
                ),
              child,
            ],
          );
        },
      ),
    );
  }
}

class _Bola {
  final double dx;
  final double dy;
  final double size;
  final bool futebol;
  final double angulo;

  const _Bola({
    required this.dx,
    required this.dy,
    required this.size,
    required this.futebol,
    required this.angulo,
  });
}

/// Centraliza o conteúdo e limita a largura máxima, deixando o layout agradável
/// também em telas largas (web/tablet/desktop).
class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = 600,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
