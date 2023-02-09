

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/services.dart';
import 'package:forge2d/src/dynamics/body.dart';
import 'package:juego_actividad/Scenes/PantallaPrincipal.dart';

import '../Elements/Star.dart';
import '../Game/MapaJuego.dart';
import 'Gota.dart';
class Ember extends SpriteAnimationComponent
    with HasGameRef<MapaJuego>, KeyboardHandler, CollisionCallbacks {
  Ember({
    required super.position,
  }) : super(size: Vector2.all(64), anchor: Anchor.center);

  int horizontalDirection = 0;
  int verticalDirection = 0;

  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 200;

  late CircleHitbox hitbox;
  bool hitByEnemy = false;



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


    hitbox=CircleHitbox(); //Para guardar y modificar la variable
    add(
      hitbox,
    );
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    //print("DEBUG: ------>>>>>> PRESION BOTON" +keysPressed.toString()); //ESTO SE VE EN EL F12 DE LA WEB

    horizontalDirection = 0;
    verticalDirection = 0;
    if((keysPressed.contains(LogicalKeyboardKey.keyA) || //TIENE AMBAS OPCIONES; TECLADO Y LETRAS
        keysPressed.contains(LogicalKeyboardKey.arrowLeft))) {
      horizontalDirection = -1;
    }
    else if((keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight))) {
      horizontalDirection = 1;
    }
    if((keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp))) {
      verticalDirection = -1;
    }
    else if((keysPressed.contains(LogicalKeyboardKey.keyS) ||
        keysPressed.contains(LogicalKeyboardKey.arrowDown))) {
      verticalDirection = 1;
    }
    
    game.setDirection(horizontalDirection, verticalDirection);


    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) { //OYHER ES EL OBTRO OBJETO CON EL QUE HE CHOCADO
    print("DEBUG: COLISION!!!"); //ESTO SE VE EN EL F12 DE LA WEB

    // TODO: implement onCollision
      if (other is Star) {
        other.removeFromParent(); //Borra la estrella al tocarla
        game.starsCollected++;
      }

      if (other is Gota) {
        hit();
      }

    super.onCollision(intersectionPoints, other);
  }

  void hit() {
    if (!hitByEnemy) {
      hitByEnemy = true;
      add(
        OpacityEffect.fadeOut(
          EffectController( //Hace que el personaje aparezca y desaparezca durante seis segundos durante seis segundos
            alternate: true,
            duration: 0.1,
            repeatCount: 6,
          ),
        )
          ..onComplete = () {
            hitByEnemy = false;
          },
      );
      game.health--;
    }
  }


  @override
  void update(double dt) {
    // TODO: implement update
    //position.add(Vector2((10.0*horizontalDirection), (10.0*verticalDirection))); //LA FORMA MAS SIMPLE Y TOSCA DE QUE SE MUEVA
    //velocity.x = horizontalDirection * moveSpeed;
    //velocity.y = verticalDirection * moveSpeed;
    //position += velocity * dt; //SI HAY LAG COGE LA DEMORA
    //game.mapComponent.position -= velocity * dt; //Mueve el mapa

    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
    }

    super.update(dt);
  }

}