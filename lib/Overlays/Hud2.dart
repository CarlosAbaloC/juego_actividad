import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:juego_actividad/Game/MapaJuego.dart';

import 'HeartHealtComponent2.dart';

class Hud2 extends PositionComponent with HasGameRef<MapaJuego> {
  Hud2({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority = 5,
  }) {
    positionType = PositionType.viewport;
  }


  int starColected = 0;
  int health = 3;
  late TextComponent _scoreTextComponent;

  @override
  Future<void>? onLoad() async {
    _scoreTextComponent = TextComponent(
      text: '$starColected',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Color.fromRGBO(10, 10, 10, 1),
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(game.size.x - 60, 80),
    );
    add(_scoreTextComponent);

    final starSprite = await game.loadSprite('star.png');
    add(
      SpriteComponent(
        sprite: starSprite,
        position: Vector2(game.size.x - 100, 80),
        size: Vector2.all(32),
        anchor: Anchor.center,
      ),
    );

    for (var i = 1; i <= health; i++) {
      final positionX = 40 * i;
      await add(
        HeartHealthComponent2(
          heartNumber: i,
          position: Vector2(positionX.toDouble(), 80),
          size: Vector2.all(32),
        ),
      );
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    starColected = game.starsCollectedP2;

    _scoreTextComponent.text = '$starColected';

    super.update(dt);
  }
}