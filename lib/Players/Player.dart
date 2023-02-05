

import 'package:flame/components.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/services.dart';
import 'package:forge2d/src/dynamics/body.dart';
import 'package:juego_actividad/Scenes/PantallaPrincipal.dart';

class Player extends BodyComponent<PantallaPrincipal> {

  final Vector2 position;
  final Vector2 size;

  Player({required this.position, required this.size}) {
    renderBody = true;
  }

  @override
  Body createBody() {

    final shape = PolygonShape();

    final vertices = [
      Vector2(0, 0),
      Vector2(size.x*0.65, 0),
      Vector2(size.x*0.65, size.y),
      Vector2(0, size.y),
    ];
    shape.set(vertices);

    final fixtureDef = FixtureDef(
      shape,
      userData: this, //Para encontrar el objeto en colision
      restitution: 0.8, //El grado de rebote despues de un golpe
      density: 1.0, //La densidad del objeto, como hay diferencia determina cuanto se mueve cada uno
      friction: 0.2, //Friccion del objeto con los otros
    );

    //final velocity = (Vector2.random() - Vector2.random()) *200;

    BodyDef def = BodyDef(
      type: BodyType.dynamic, //Se mueve por factores externos
      position: position, //La posicion del objeto
      //angle: velocity.angleTo(Vector2(1, 0)),
      //linearVelocity: velocity
    );


    return world.createBody(def)..createFixture(fixtureDef); //Crea un cuerpo, body, y su anclaje en el mundo real
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    //print("DEBUG:---------------->>>>>>>>"+keysPressed.toString());

    //final isKeyDown = event is RawKeyDownEvent; //Si esta presionado
    //final isKeyUp = event is RawKeyUpEvent; //Si dejo de estar presionado

    if(keysPressed.contains(LogicalKeyboardKey.arrowRight)){
      center.add(Vector2(3, 0));
      //body.setTransform(body.position+Vector2(3, 0), 0);
      return true;
    }
    else if(keysPressed.contains(LogicalKeyboardKey.arrowLeft)){
      center.add(Vector2(-3, 0));
      return true;
    }
    else if(keysPressed.contains(LogicalKeyboardKey.arrowUp)){
      center.add(Vector2(0, -3));
      return true;
    }
    else if(keysPressed.contains(LogicalKeyboardKey.arrowDown)){
      center.add(Vector2(0, 3));
      return true;
    }
    return false; //Evita que hagan alguna accion aparte del padre

  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
  }


}