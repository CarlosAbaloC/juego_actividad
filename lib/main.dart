import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'Scenes/PantallaPrincipal.dart';

void main() {
  PantallaPrincipal game = PantallaPrincipal();
  GameWidget gameWidget = GameWidget(game: game);

  runApp(gameWidget);
}
