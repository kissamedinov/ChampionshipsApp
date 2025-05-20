import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/match.dart';
import 'match_card.dart';

/// Анимированная обёртка над MatchCard: slide-in + tap-бросок + doubleTap
class AnimatedMatchCard extends StatefulWidget {
  final Match match;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;

  const AnimatedMatchCard({
    Key? key,
    required this.match,
    required this.onTap,
    required this.onDoubleTap,
  }) : super(key: key);

  @override
  _AnimatedMatchCardState createState() => _AnimatedMatchCardState();
}

class _AnimatedMatchCardState extends State<AnimatedMatchCard>
    with TickerProviderStateMixin {
  late final AnimationController _entryCtrl;
  late final Animation<Offset> _slide;

  late final AnimationController _tapCtrl;
  late final Animation<double> _tapScale;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));
    _entryCtrl.forward();

    _tapCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 100),
    );
    _tapScale = Tween<double>(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _tapCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _tapCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: GestureDetector(
        onTapDown: (_) => _tapCtrl.forward(),
        onTapUp: (_) {
          _tapCtrl.reverse();
          widget.onTap();
        },
        onTapCancel: () => _tapCtrl.reverse(),
        onDoubleTap: widget.onDoubleTap,
        child: ScaleTransition(
          scale: _tapScale,
          child: MatchCard(
            match: widget.match,
            onTap: widget.onTap,
            onDoubleTap: widget.onDoubleTap,
          ),
        ),
      ),
    );
  }
}

/// Иконка "Избранное" с анимацией пульсации и смены цвета
class AnimatedFavoriteIcon extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const AnimatedFavoriteIcon({Key? key, required this.isFavorite, required this.onTap}) : super(key: key);

  @override
  _AnimatedFavoriteIconState createState() => _AnimatedFavoriteIconState();
}

class _AnimatedFavoriteIconState extends State<AnimatedFavoriteIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<Color?> _color;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scale = Tween<double>(begin: 1.0, end: 1.3)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _color = ColorTween(begin: Colors.grey, end: Colors.red).animate(_ctrl);

    if (widget.isFavorite) _ctrl.value = 1.0;
  }

  @override
  void didUpdateWidget(covariant AnimatedFavoriteIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite != widget.isFavorite) {
      widget.isFavorite ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          return Transform.scale(
            scale: _scale.value,
            child: Icon(
              widget.isFavorite ? Icons.star : Icons.star_border,
              color: _color.value,
              size: 30,
            ),
          );
        },
      ),
    );
  }
}

/// Подпрыгивающая кнопка "Купить билет" с паддингом и поворотом
class AnimatedBuyButton extends StatefulWidget {
  final VoidCallback onPressed;
  const AnimatedBuyButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  _AnimatedBuyButtonState createState() => _AnimatedBuyButtonState();
}

class _AnimatedBuyButtonState extends State<AnimatedBuyButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<EdgeInsets> _pad;
  late final Animation<double> _rot;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _pad = EdgeInsetsTween(
      begin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      end: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _rot = Tween<double>(begin: 0, end: 0.05).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          return Padding(
            padding: _pad.value,
            child: Transform.rotate(
              angle: _rot.value,
              child: ElevatedButton(
                onPressed: widget.onPressed,
                child: const Text('Купить билет'),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Загрузочный индикатор через Lottie
class LottieLoader extends StatelessWidget {
  const LottieLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/loader.json',
        width: 100,
        height: 100,
        repeat: true,
        animate: true,
      ),
    );
  }
}