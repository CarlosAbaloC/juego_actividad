import 'package:flutter/material.dart';

import 'package:flame/components.dart';
import 'package:juego_actividad/Game/MapaJuego.dart';

import 'HeartHealtComponent.dart';

class Hud extends PositionComponent with HasGameRef<MapaJuego> {
  Hud({
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

  late TextComponent _scoreTextComponent;
  late TextComponent _scoreTextComponent2;

  @override
  Future<void>? onLoad() async {
    _scoreTextComponent = TextComponent(
      text: '${game.starsCollected}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Color.fromRGBO(10, 10, 10, 1),
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(60, 80),
    );
    add(_scoreTextComponent);

    final starSprite = await game.loadSprite('star.png');
    add(
      SpriteComponent(
        sprite: starSprite,
        position: Vector2(100, 80),
        size: Vector2.all(32),
        anchor: Anchor.center,
      ),
    );

    for (var i = 1; i <= game.health; i++) {
      final positionX = 40 * i;
      await add(
        HeartHealthComponent(
          heartNumber: i,
          position: Vector2(positionX.toDouble(), 20),
          size: Vector2.all(32),
        ),
      );
    }

    _scoreTextComponent2 = TextComponent(
      text: '${game.starsCollected}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Color.fromRGBO(10, 10, 10, 1),
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(840, 80),
    );
    add(_scoreTextComponent2);

    final starSprite2 = await game.loadSprite('star.png');
    add(
      SpriteComponent(
        sprite: starSprite2,
        position: Vector2(880, 80),
        size: Vector2.all(32),
        anchor: Anchor.center,
      ),
    );

    for (var i = 1; i <= game.health; i++) {
      final positionX = 40 * i;
      final posGlobal = 800 + positionX;
      await add(
        HeartHealthComponent(
          heartNumber: i,
          position: Vector2(posGlobal.toDouble(), 20),
          size: Vector2.all(32),
        ),
      );
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _scoreTextComponent.text = '${game.starsCollected}'; //Cambia la puntuacion por cada estrella
    super.update(dt);
  }
}