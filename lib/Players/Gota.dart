


import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';

import '../Game/MapaJuego.dart';

class Gota extends SpriteAnimationComponent
    with HasGameRef<MapaJuego> {
  Gota({
    required super.position,
    required super.size,
  }) : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('water_enemy.png'), //Accede al cache de ember png
      SpriteAnimationData.sequenced(
        amount: 2, //Cuantos cortes hay
        textureSize: Vector2.all(16), //El tamaño del sprite, para recortarlo
        stepTime: 0.12,
      ),
    );

    //Como no tiene tamaño propio se agrega al de la gota
    add(RectangleHitbox()..collisionType = CollisionType.passive);     //Pasivo solo avisa si colisiona con elemento activo

    /*
    add( //Para darle movimiento a las gotas
      MoveEffect.by(
        Vector2(-2 * size.x, 0),
        EffectController(
          duration: 3,
          alternate: true,
          infinite: true,
        ),
      ),
    );
     */
  }
  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
    if (position.x < -size.x || game.health <= 0) {
      //removeFromParent();
    }
  }
}