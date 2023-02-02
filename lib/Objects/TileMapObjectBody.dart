

import 'package:flame_forge2d/body_component.dart';
import 'package:juego_actividad/Scenes/PantallaPrincipal.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:forge2d/src/dynamics/body.dart';

class TiledMapObjectBody extends BodyComponent<PantallaPrincipal> {
  final TiledObject tiledObject;
  TiledMapObjectBody(this.tiledObject){
    renderBody=true; //Pinta el espacio de la colision, true o false colisiona igual
  }

  @override
  Body createBody() {
    // TODO: implement createBody

    //Primero se definen los cuerpos, no sus formas, todos seran iguales
    final bodyDef = BodyDef()
      ..position = Vector2(tiledObject.x, tiledObject.y) //Posicion del objeto, se lo da el objeto en si
      ..type = BodyType.static;
    Body body=world.createBody(bodyDef);


    //Defino la forma de los distintos tipos de cuerpos
    if(tiledObject.isRectangle){ //CUADRADO
      PolygonShape shape = PolygonShape();

      final vertices = [
        Vector2(0, 0),
        Vector2(tiledObject.width, 0),
        Vector2(tiledObject.width, tiledObject.height),
        Vector2(0, tiledObject.height),
      ];
      shape.set(vertices);


      final fixtureDef = FixtureDef(shape)
        ..userData = this
        ..restitution = 0.8
        ..density = 1.0
        ..friction = 0.2;

      body.createFixture(fixtureDef);
    }
    else if(tiledObject.isPolygon){ //POLIGONO
      ChainShape shape = ChainShape();

      final List<Vector2> vertices = [];
      for (final polygon in tiledObject.polygon) {
        shape.vertices.add(Vector2(polygon.x, polygon.y));
      }

      shape.vertices.add(Vector2(tiledObject.polygon[0].x, tiledObject.polygon[0].y));

      final fixtureDef = FixtureDef(shape)
        ..userData = this
        ..restitution = 0.8
        ..density = 1.0
        ..friction = 0.2;

      body.createFixture(fixtureDef);

      //shape.set(vertices);
    }

    return body;
  }
}