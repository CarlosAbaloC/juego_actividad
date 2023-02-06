import 'package:flame/game.dart';
import 'package:flutter/material.dart';


import 'Game/MapaJuego.dart';
import 'Scenes/PantallaPrincipal.dart';


void main() {
  runApp(
    const GameWidget<MapaJuego>.controlled(
      gameFactory: MapaJuego.new,
    ),
  );
}

/*
void main() {

  MapaJuego game = MapaJuego();

  //PantallaPrincipal game = PantallaPrincipal();
  GameWidget gameWidget = GameWidget(game: game);

  runApp(gameWidget);
}

 */
