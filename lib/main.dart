import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:juego_actividad/ux/joypad.dart';
import 'package:juego_actividad/widgets/GameOver.dart';
import 'package:juego_actividad/widgets/MainMenu.dart';


import 'Game/MapaJuego.dart';
import 'Scenes/PantallaPrincipal.dart';


void main() {
  runApp(
    /*
    const GameWidget<MapaJuego>.controlled(
      gameFactory: MapaJuego.new,
    ),
     */
    GameWidget<MapaJuego>.controlled(
      gameFactory: MapaJuego.new,
      overlayBuilderMap: { //Este metodo permite ver una cosa encima de la otra
        'MainMenu': (_, game) => MainMenu(game: game),
        'GameOver': (_, game) => GameOver(game: game),
        'Joypad': (_, game) => Joypad(onDirectionChanged: game.joyspadMoved),

        //Pull request

      },
      initialActiveOverlays: const ['MainMenu'],
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
