

import 'package:flame/components.dart';
import 'package:juego_actividad/Game/MapaJuego.dart';

enum HeartState {
  available,
  unavailable,
}

class HeartHealthComponent extends SpriteGroupComponent<HeartState>
    with HasGameRef<MapaJuego> {
  final int heartNumber;

  HeartHealthComponent({
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

    current = HeartState.available; //Hace esto por cada uno de los corazones que haya encima de la pantalla
  }

  @override
  void update(double dt) {
    if (game.health < heartNumber) { //No para de preguntar si esta por debajo la cantidad de corazones que el corazon en si para dejarlo en modo oscuro, lo hace a cada uno
      current = HeartState.unavailable;
    } else {
      current = HeartState.available;
    }
    super.update(dt);
  }
}