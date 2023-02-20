

import 'package:flame/effects.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:forge2d/src/dynamics/body.dart';
import 'package:juego_actividad/Players/Gota.dart';

import '../Game/MapaJuego.dart';

class GotaBody extends BodyComponent<MapaJuego> {
  Vector2 posXY;
  Vector2 tamWH;

  GotaBody({required this.posXY, required this.tamWH}):super();

  @override
  Body createBody() {
    // TODO: implement createBody

    BodyDef bodyDef = BodyDef(type: BodyType.dynamic, position: posXY); //Crea la definicion del cuerpo
    Body cuerpo = world.createBody(bodyDef);
    CircleShape shape = CircleShape();
    shape.radius=tamWH.x/2;
    cuerpo.createFixtureFromShape(shape);
    return cuerpo;
  }

  @override
  Future<void> onLoad() async{
    // TODO: implement onLoad
    await super.onLoad();

    Gota gota = Gota(position: Vector2.zero(), size: tamWH); //Para que este en la posicion cero del padre, no del global
    add(gota);
    print(posXY);

    add(
      MoveEffect.by(
        Vector2(-2 * tamWH.x, 0),
        EffectController(
          duration: 3,
          alternate: true,
          infinite: true,
        ),
      ),
    );
  }

}
