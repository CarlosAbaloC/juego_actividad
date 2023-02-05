
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../Objects/TileMapObjectBody.dart';
import '../Players/Ember.dart';
import '../Players/Player.dart';

class MapaJuego extends FlameGame{

  MapaJuego();


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

    
    TiledComponent mapComponent = await TiledComponent.load('Actividad.tmx', Vector2(60,30));

    Ember jugador = Ember(position: Vector2(200, 100));
    add(jugador);

  }

}