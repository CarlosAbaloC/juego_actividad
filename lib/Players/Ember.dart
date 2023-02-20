

import 'dart:io';

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
import '../ux/joypad.dart';
import 'Gota.dart';

class EmberBody extends BodyComponent<MapaJuego> with KeyboardHandler{

  Vector2 position;
  Vector2 size = Vector2(48, 48); //PARA HACER EL EMBER MAS PEQUEÑO!!!!!!
  late Ember ember;

  int horizontalDirection = 0;
  int verticalDirection = 0;

  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 200;
  double jumSpeed = 0;
  double iShowDelay = 5;
  bool elementAdded = false;

  EmberBody({required this.position});

  @override
  Future<void> onLoad() async{
    // TODO: implement onLoad
    await super.onLoad();
    //sleep(Duration(mi));
    //await Future.delayed(Duration(seconds: 3)); //PARA QUE TARDE EN CARGAR

    ember=Ember(position: Vector2.zero()); //Lo colocas a cero para que no se duplique la posicion, que si lo pones al 100, 100 de un objeto que esta al 200 200 de la pantalla total
    ember.size=size;

    add(ember);
    renderBody=false; //PARA DIBUJAR LA FORMA DEL OBJETO, NO DEL SPRITE DIBUJADO
    //camera.followBodyComponent(this);


    game.overlays.addEntry("Joypad", (_, game) => Joypad(onDirectionChanged: joypadMoved));

  }

  @override
  Body createBody() {
    // TODO: implement createBody
    BodyDef definicionCuerpo = BodyDef(position: position,
        type: BodyType.dynamic,
        fixedRotation: true, //Para que no rote
        //gravityScale: Vector2(0,5), //Si lo pones en negativo se ira flotando

    );
    Body cuerpo = world.createBody(definicionCuerpo);


    /*
    final shape = PolygonShape(); //PARA HACER UN RECTANGULO
    final vertices = [
      Vector2(0, 0),
      Vector2(64, 0),
      Vector2(64, 64),
      Vector2(0, 64)
    ];
    shape.set(vertices); //Para que coja el tamaño
     */


    final shape = CircleShape();
    shape.radius = size.x/2;
    //Para hacer el cuerpo fisico del ember circular en vez de cuadrado con vertices
    //Asi tiene el tamaño del size


    FixtureDef fixtureDef = FixtureDef(
        shape,
      //density: 10.0, //Para darle densidad, si esta en un borde cae
      //friction: 10.0,
      //restitution: 0.5, //El rebote de la colision

    );
    cuerpo.createFixture(fixtureDef);
    return cuerpo;
  }

  @override
    void onMount() { //Sirve para asegurarse de que esta cargado
      // TODO: implement onMount
      super.onMount();
      //camera.followBodyComponent(this);
    }


    void joypadMoved(Direction direction){


      if(direction==Direction.none) {
        horizontalDirection=0;
        verticalDirection=0;
      }
      if(direction==Direction.left) {
        horizontalDirection = -1;
      }
      else if(direction==Direction.right) {
        horizontalDirection = 1;
      }
      if(direction==Direction.up) {
        verticalDirection = -1;
      }
      else if(direction==Direction.down) {
        verticalDirection = 1;
      }
    }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    //print("DEBUG: ------>>>>>> PRESION BOTON" +keysPressed.toString()); //ESTO SE VE EN EL F12 DE LA WEB

    horizontalDirection = 0;
    verticalDirection = 0;
    if((keysPressed.contains(LogicalKeyboardKey.keyA)) || (keysPressed.contains(LogicalKeyboardKey.keyD)) ||
        (keysPressed.contains(LogicalKeyboardKey.keyW)) || (keysPressed.contains(LogicalKeyboardKey.keyS))) {
      if ((keysPressed.contains(LogicalKeyboardKey.keyA))) {
        horizontalDirection = -1;
      }
      else if ((keysPressed.contains(LogicalKeyboardKey.keyD))) {
        horizontalDirection = 1;
      }
      if ((keysPressed.contains(LogicalKeyboardKey.keyW))) {
        verticalDirection = -1;
      }
      else if ((keysPressed.contains(LogicalKeyboardKey.keyS))) {
        verticalDirection = 1;
      }

      if (keysPressed.contains(LogicalKeyboardKey.space)) {
        jumSpeed = 2000;
      }
      else {
        jumSpeed = 0;
      }

      game.setDirection(horizontalDirection, verticalDirection);
    } else {
      horizontalDirection =0;
      verticalDirection =0;
    }


    return true;
  }


  @override
  void update(double dt) {

    /*
    if(!elementAdded) {
      iShowDelay -= dt;
      if (iShowDelay < 0) {
        add(ember);
        elementAdded = true;
      }
    }

     */


    // TODO: implement update
    //position.add(Vector2((10.0*horizontalDirection), (10.0*verticalDirection))); //LA FORMA MAS SIMPLE Y TOSCA DE QUE SE MUEVA
    velocity.x = horizontalDirection * moveSpeed;
    velocity.y = verticalDirection * moveSpeed;
    velocity.y += -1 * jumSpeed;
    jumSpeed= 0;
    //position += velocity * dt; //SI HAY LAG COGE LA DEMORA
    //game.mapComponent.position -= velocity * dt; //Mueve el mapa


    center.add((velocity * dt)); //Para actualizar la ubicacion pero sin modificar el position

    body.applyLinearImpulse(velocity*dt);
    body.applyAngularImpulse(3);

    if (horizontalDirection < 0 && ember.scale.x > 0) {
      ember.flipHorizontallyAroundCenter();
      //ember.flipHorizontally();
    } else if (horizontalDirection > 0 && ember.scale.x < 0) {
      ember.flipHorizontallyAroundCenter();
      //ember.flipHorizontally();
    }

    if (position.x < -size.x || game.health <= 0) {
      game.setDirection(0, 0);
      removeFromParent();

    }

    super.update(dt);
  }

}



class Ember extends SpriteAnimationComponent
    with HasGameRef<MapaJuego>, KeyboardHandler, CollisionCallbacks {
  Ember({
    required super.position,
  }) : super(anchor: Anchor.center);





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


    //Ya no se usa
    //hitbox=CircleHitbox(); //Para guardar y modificar la variable
    //add(hitbox,);
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



  /*


  int horizontalDirection = 0;
  int verticalDirection = 0;

  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 200;


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

    if (position.x < -size.x || game.health <= 0) {
      game.setDirection(0, 0);
      removeFromParent();

    }

    super.update(dt);
  }


   */
}