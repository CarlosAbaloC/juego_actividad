
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../Elements/Star.dart';
import '../Players/Ember.dart';
import '../Players/Gota.dart';

class MapaJuego extends FlameGame with HasKeyboardHandlerComponents {

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
    ObjectGroup? posPlayerUno = mapComponent.tileMap.getLayer<ObjectGroup>("posPlayer1");
    ObjectGroup? posPlayerDos = mapComponent.tileMap.getLayer<ObjectGroup>("posPlayer2");

    print("DEBUG: ------>>>>>>>>>>" + estrellas!.objects.toString());
    for(final estrella in estrellas.objects) {
      print("DEBUG: ------>>>>>>>>>>" + estrellas.x.toString() + "    " + estrella.y.toString());
      Star estrellaComponent = Star(position: Vector2(estrella.x, estrella.y));

      add(estrellaComponent);
    }

    for(final gota in gotas!.objects) {
      print("DEBUG: ------>>>>>>>>>>" + estrellas.x.toString() + "    " + gota.y.toString());
      Gota gotaComponent = Gota(position: Vector2(gota.x, gota.y));
      add(gotaComponent);
    }

    print("DEBUG: ------>>>>>>>>>>" + posPlayerDos!.objects.toString());
    for(final estrella in estrellas.objects) {
      print("DEBUG: ------>>>>>>>>>>" + estrellas.x.toString() + "    " + estrella.y.toString());
      Star estrellaComponent = Star(position: Vector2(estrella.x, estrella.y));

      add(estrellaComponent);
    }



    Ember jugador = Ember(position: Vector2(posPlayerUno!.objects.first.x, posPlayerUno!.objects.first.y));
    add(jugador);

  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 173, 223, 247);
  }

}