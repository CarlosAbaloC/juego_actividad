

import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:forge2d/src/dynamics/body.dart';

import '../Game/MapaJuego.dart';

class SueloBody extends BodyComponent<MapaJuego> {

  TiledObject tiledBody;
  SueloBody({required  this.tiledBody});


  @override
  Future<void> onLoad() {
    // TODO: implement onLoad
    renderBody=false; //Para que no se pinte
    return super.onLoad();
  }

  @override
  Body createBody() {

    late FixtureDef fixtureDef;

    if(tiledBody.isRectangle) {
      PolygonShape shape = PolygonShape();
      final vertices = [
        Vector2(0, 0),
        Vector2(tiledBody.width, 0),
        Vector2(tiledBody.width, tiledBody.height),
        Vector2(0, tiledBody.height)
      ];
      shape.set(vertices); //Para que coja el tamaño
      fixtureDef= FixtureDef(shape);
    }

    if(tiledBody.isPolygon) {
      print("DEBUG: " + tiledBody.id.toString());
      ChainShape shape = ChainShape();
      List<Vector2> vertices = [];
      for(final point in tiledBody.polygon) {
        shape.vertices.add(Vector2(point.x, point.y));
      }
      Point point0 = tiledBody.polygon[0]; //SINO NO ENTRA EN LA LISTA DE VECTORES
      shape.vertices.add(Vector2(point0.x, point0.y)); //PARA CERRAR EL POLIGONO

      fixtureDef= FixtureDef(shape);

    }

    BodyDef definicionCuerpo = BodyDef(position: Vector2(tiledBody.x,tiledBody.y), type: BodyType.static); //Static/dinamic si le afecta la gravedad o no
    Body cuerpo = world.createBody(definicionCuerpo);





    //FixtureDef fixtureDef = FixtureDef(shape);
    cuerpo.createFixture(fixtureDef);
    return cuerpo;
  }

}