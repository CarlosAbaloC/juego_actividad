
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../Elements/Star.dart';
import '../Overlays/Hud.dart';
import '../Players/Ember.dart';
import '../Players/Gota.dart';

class MapaJuego extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {

  MapaJuego();


  late TiledComponent mapComponent;
  int horizontalDirection = 0;
  int verticalDirection = 0;

  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 200;

  List<PositionComponent> objetosVisuales = [];

  int starsCollected = 0;
  int health = 3;

  late Ember _jugador;
  late Ember _jugador2;


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

    initializeGame(true);

  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 173, 223, 247);
  }

  @override
  void update(double dt) {
    // TODO: implement update
    //position.add(Vector2((10.0*horizontalDirection), (10.0*verticalDirection))); //LA FORMA MAS SIMPLE Y TOSCA DE QUE SE MUEVA
    velocity.x = horizontalDirection * moveSpeed;
    velocity.y = verticalDirection * moveSpeed;
    //position += velocity * dt; //SI HAY LAG COGE LA DEMORA
    mapComponent.position -= velocity * dt; //Mueve el mapa

    for(final objVisual in objetosVisuales) {
      objVisual.position -= velocity * dt; //Un menos para que vaya en direccion contraria a tu personaje asi hace el efecto de movimiento
    }

    super.update(dt);
  }

  void setDirection(int horizontalDirection, int verticalDirection){
    this.horizontalDirection = horizontalDirection;
    this.verticalDirection = verticalDirection;
  }

  void initializeGame(bool loadHud) async{
    // Assume that size.x < 3200

    mapComponent = await TiledComponent.load('ActividadTiledMap.tmx', Vector2(32,32));
    add(mapComponent);

    ObjectGroup? estrellas = mapComponent.tileMap.getLayer<ObjectGroup>("Estrellas");
    ObjectGroup? gotas = mapComponent.tileMap.getLayer<ObjectGroup>("Gotas");
    ObjectGroup? posPlayerUno = mapComponent.tileMap.getLayer<ObjectGroup>("posPlayer1");
    ObjectGroup? posPlayerDos = mapComponent.tileMap.getLayer<ObjectGroup>("posPlayer2");

    print("DEBUG: ------>>>>>>>>>>" + estrellas!.objects.toString());
    for(final estrella in estrellas.objects) {
      print("DEBUG: ------>>>>>>>>>>" + estrellas.x.toString() + "    " + estrella.y.toString());
      Star estrellaComponent = Star(position: Vector2(estrella.x, estrella.y));
      objetosVisuales.add(estrellaComponent);
      add(estrellaComponent);
    }

    for(final gota in gotas!.objects) {
      print("DEBUG: ------>>>>>>>>>>" + estrellas.x.toString() + "    " + gota.y.toString());
      Gota gotaComponent = Gota(position: Vector2(gota.x, gota.y));
      objetosVisuales.add(gotaComponent);
      add(gotaComponent);
    }





    _jugador = Ember(position: Vector2(posPlayerUno!.objects.first.x, posPlayerUno!.objects.first.y));
    add(_jugador);

    _jugador2 = Ember(position: Vector2(posPlayerDos!.objects.first.x, posPlayerDos!.objects.first.y));
    add(_jugador2);

    if (loadHud) {
      add(Hud());
    }
  }

  void reset() {
    starsCollected = 0;
    health = 3;
    initializeGame(false);
  }

}