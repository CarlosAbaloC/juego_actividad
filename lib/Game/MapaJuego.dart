
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../Players/Ember.dart';

class MapaJuego extends FlameGame{

  MapaJuego();


  late TiledComponent mapComponent;

  @override
  Future<void>? onLoad() async {
    // TODO: implement onLoad
    await super.onLoad();
    await images.loadAll([
      'block.png',
      'ember.png',
      'ground.png',
      'heart_half.png',
      'heart.png',
      'star.png',
      'water_enemy.png',
    ]);

    
    TiledComponent mapComponent = await TiledComponent.load('ActividadTiledMap.tmx', Vector2(32,32));
    add(mapComponent);

    ObjectGroup? estrellas = mapComponent.tileMap.getLayer<ObjectGroup>("Estrellas");
    ObjectGroup? gotas = mapComponent.tileMap.getLayer<ObjectGroup>("Gotas");

    print("DEBUG: ------>>>>>>>>>>" + estrellas!.objects.toString());
    for(final estrella in estrellas.objects) {

    }

    Ember jugador = Ember(position: Vector2(200, 200));
    add(jugador);

  }

}