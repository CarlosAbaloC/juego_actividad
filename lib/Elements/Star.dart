

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:juego_actividad/Game/MapaJuego.dart';

class Star extends SpriteComponent with HasGameRef<MapaJuego>{

  Star({required super.position}): super(size: Vector2.all(64), anchor: Anchor.bottomCenter);

  @override
  Future<void>? onLoad() async {
    // TODO: implement onLoad
    await super.onLoad();


    final platformImage = game.images.fromCache('star.png');
    sprite = Sprite(platformImage); //Solo crear el sprite si extiende de sprite component

    //SpriteComponent component = SpriteComponent.fromImage(game.images.fromCache (), anchor: Anchor.bottomCenter);
    add(RectangleHitbox()..collisionType = CollisionType.passive);

  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
  }

}