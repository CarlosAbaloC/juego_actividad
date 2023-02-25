

import 'package:flame/components.dart';
import 'package:juego_actividad/Game/MapaJuego.dart';

enum HeartState {
  available,
  unavailable,
}

class HeartHealthComponent2 extends SpriteGroupComponent<HeartState>
    with HasGameRef<MapaJuego> {
  final int heartNumber;

  HeartHealthComponent2({
    required this.heartNumber,
    required super.position,
    required super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.priority,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final availableSprite = await game.loadSprite(
      'heart.png',
      srcSize: Vector2.all(32),
    );

    final unavailableSprite = await game.loadSprite(
      'heart_half.png',
      srcSize: Vector2.all(32),
    );

    sprites = {
      HeartState.available: availableSprite,
      HeartState.unavailable: unavailableSprite,
    };

    current = HeartState.available;
  }
  @override
  void update(double dt) {
    if (game.healthP2 < heartNumber) {
      current = HeartState.unavailable;
    } else {
      current = HeartState.available;
    }
    super.update(dt);
  }
}