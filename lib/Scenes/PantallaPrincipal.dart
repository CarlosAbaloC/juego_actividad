

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../Objects/TileMapObjectBody.dart';
import '../Players/Player.dart';

class PantallaPrincipal extends Forge2DGame{


  late TiledComponent mapComponent;

  PantallaPrincipal():super(gravity: Vector2(0, 9.8), zoom: 1);

  @override
  Future<void>? onLoad() async {
    // TODO: implement onLoad
    await super.onLoad();

    mapComponent = await TiledComponent.load('Actividad.tmx', Vector2.all(32));
    add(mapComponent);

    final capaObjGroup = mapComponent.tileMap.getLayer<ObjectGroup>('Objetos'); //Pide los objetos que estan en la capa objetos, los objetos con "cuerpo"

    for(final obj in capaObjGroup!.objects) { //Un for para no ir objeto por objeto
      TiledMapObjectBody tmob = TiledMapObjectBody(obj); //Pasa los objetos al tiled que los define en el mapa
      add(tmob);
    }

    //Ubicacion de inicio del personaje
    Player personaje = Player(position: Vector2(size.x/1.5,0), size: size*0.1); //size/2 es el centro de la pantalla
    add(personaje);

  }

}