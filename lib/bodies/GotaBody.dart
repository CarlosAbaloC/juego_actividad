

import 'package:flame/collisions.dart';
import 'package:flame/effects.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:forge2d/src/dynamics/body.dart';
import 'package:juego_actividad/Players/Gota.dart';

import '../Game/MapaJuego.dart';

class GotaBody extends BodyComponent<MapaJuego> with ContactCallbacks {
  Vector2 posXY;
  Vector2 tamWH;
  double xIni = 0;
  double xFin = 0;
  double xContador = 0;
  double dAnimDireccion=-1;
  double dVelocidadAnim=1;

  GotaBody({required this.posXY, required this.tamWH}):super();

  @override
  Body createBody() {
    // TODO: implement createBody

    BodyDef bodyDef = BodyDef(type: BodyType.dynamic, position: posXY, userData: this); //Crea la definicion del cuerpo //El userData para que colisione
    Body cuerpo = world.createBody(bodyDef);
    CircleShape shape = CircleShape();
    shape.radius=tamWH.x/2;

    //userData: this //To be able to determine object in collision
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

    xIni = posXY.x;
    xFin = -20; //Desde donde hasta donde se mueve la gota
    xContador = 0;
    renderBody=false;
    /*
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

     */
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
    if(dAnimDireccion<0){
      xContador=xContador+dVelocidadAnim;
      center.sub(Vector2(dVelocidadAnim, dVelocidadAnim));
    }
    else{
      xContador=xContador+dVelocidadAnim;
      center.add(Vector2(dVelocidadAnim, dVelocidadAnim));
    }

    if(xContador>xFin){
      xContador=0;
      dAnimDireccion=dAnimDireccion*-1;
    }

  }

  void destruir(){
    removeFromParent();
    //gameRef.remove(this);
  }

  @override
  void beginContact(Object other, Contact contact) {
    // TODO: implement beginContact
    super.beginContact(other, contact);
  }

}
