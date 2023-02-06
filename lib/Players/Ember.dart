

import 'package:flame/components.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/services.dart';
import 'package:forge2d/src/dynamics/body.dart';
import 'package:juego_actividad/Scenes/PantallaPrincipal.dart';

import '../Game/MapaJuego.dart';
class Ember extends SpriteAnimationComponent
    with HasGameRef<MapaJuego> {
  Ember({
    required super.position,
  }) : super(size: Vector2.all(64), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('ember.png'), //Accede al cache de ember png
      SpriteAnimationData.sequenced(
        amount: 4, //Cuantos cortes hay
        textureSize: Vector2.all(16), //El tamaño del sprite, para recortarlo
        stepTime: 0.12,
      ),
    );
  }
}