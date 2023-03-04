import 'package:flame/components.dart';
import 'package:juego_actividad/Game/MapaJuego.dart';

import '../Elements/Star.dart';
import '../bodies/GotaBody.dart';
import '../ux/joypad.dart';
import 'Gota.dart';
import 'Player2.dart';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:forge2d/src/dynamics/body.dart';

import '../ux/joypad.dart';
import 'Player2.dart';


class Player2Body extends BodyComponent<MapaJuego> with KeyboardHandler, ContactCallbacks{

  Vector2 position;
  Vector2 size=Vector2(48, 48);
  late Player2 player2;
  int verticalDirection = 0;
  int horizontalDirection = 0;
  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 200;
  double jumpSpeed=0;
  double iShowDelay=5;
  bool elementAdded=false;
  bool hitByEnemy = false;


  Player2Body({required this.position});

  @override
  Future<void> onLoad() async{
    // TODO: implement onLoad
    await super.onLoad();
    //sleep(Duration(mi));
    //Future.delayed(Duration(seconds: 3));

    player2=Player2(position: Vector2.zero());
    player2.size=size;
    add(player2);
    renderBody=false;

    //game.overlays.addEntry('Joypad', (_, game) => Joypad(onDirectionChanged:joypadMoved));

  }

  @override
  Body createBody() {
    // TODO: implement createBody
    BodyDef definicionCuerpo= BodyDef(position: position,
        type: BodyType.dynamic,fixedRotation: true);
    Body cuerpo= world.createBody(definicionCuerpo);


    final shape=CircleShape();
    shape.radius=size.x/2;

    FixtureDef fixtureDef=FixtureDef(
      shape,
      //density: 10.0,
      //friction: 0.2,
      //restitution: 0.5,
      userData: this, //Detectar colision
    );
    cuerpo.createFixture(fixtureDef);

    return cuerpo;
  }


  @override
  void beginContact(Object other, Contact contact) {
    print("DEBUG: COLISION!!!"); //ESTO SE VE EN EL F12 DE LA WEB
    super.beginContact(other, contact);
    // TODO: implement onCollision
    if (other is Star) {
      other.removeFromParent(); //Borra la estrella al tocarla
      game.starsCollected++;
    }

    if (other is GotaBody) {
      hit();
    }
  }

  void hit() {
    if (!hitByEnemy) {
      hitByEnemy = true;
      add(
        OpacityEffect.fadeOut(
          EffectController( //Hace que el personaje aparezca y desaparezca durante seis segundos durante seis segundos
            alternate: true,
            duration: 0.1,
            repeatCount: 6,
          ),
        )
          ..onComplete = () {
            hitByEnemy = false;
          },
      );
      game.health--;
    }
  }

  @override
  void onMount() {
    super.onMount();
    //camera.followBodyComponent(this);
  }

  void joypadMoved(Direction direction){

    if(direction==Direction.none) {
      horizontalDirection = 0;
      verticalDirection = 0;
    }

    if(direction==Direction.left){
      horizontalDirection=-1;
    }
    else if(direction==Direction.right){
      horizontalDirection=1;
    }

    if(direction==Direction.up){
      verticalDirection=-1;
    }
    else if(direction==Direction.down){
      verticalDirection=1;
    }

  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    //print("DEBUG: ----------->>>>>>>> BOTON PRESIONADO: "+keysPressed.toString());
    //final isKeyDown = event is RawKeyDownEvent;
    //final isKeyUp = event is RawKeyUpEvent;

    horizontalDirection = 0;
    verticalDirection = 0;

    if(keysPressed.contains(LogicalKeyboardKey.arrowLeft)){
      horizontalDirection=-1;
    }
    else if(keysPressed.contains(LogicalKeyboardKey.arrowRight)){
      horizontalDirection=1;
    }
    if(keysPressed.contains(LogicalKeyboardKey.arrowUp)){
      verticalDirection=-1;
    }
    else if(keysPressed.contains(LogicalKeyboardKey.arrowDown)){
      verticalDirection=1;
    } else{
      jumpSpeed=0;
    }

    /*
    if(keysPressed.contains(LogicalKeyboardKey.space) && (event is RawKeyDownEvent) && jumpSpeed==0){
      jumpSpeed=2000;
    }

    if(keysPressed.contains(LogicalKeyboardKey.space) && (event is RawKeyUpEvent) && jumpSpeed==2000){
      jumpSpeed=0;
    }
    */
    game.setDirection(horizontalDirection,verticalDirection);


    return true;
  }


  @override
  void update(double dt) {

    /*if(!elementAdded) {
      iShowDelay -= dt;
      if (iShowDelay < 0) {
        add(emberPlayer);
        elementAdded=true;
      }
    }*/

    // TODO: implement update
    //position.add(Vector2(10.0*horizontalDirection, 10.0*verticalDirection));
    velocity.x = horizontalDirection * moveSpeed;
    velocity.y = verticalDirection * moveSpeed;
    velocity.y += -1 * jumpSpeed;
    jumpSpeed = 0;
    //game.mapComponent.position -= velocity * dt;

    /**
     * IMPORTANTE! Para mover el personaje debemos APLICAR FUERZAS al CUERPO
     * NO mover las coordenadas usando el center ya que luego cuando el objeto REPOSA en el suelo,
     * este pasa a modo "dormido" y para despertarle DEBEMOS usar FUERZAS y no tocar el center.
     * Ver documentacion sobre BOX2D (https://www.iforce2d.net/b2dtut/forces)
     */
    //center.add((velocity * dt));
    body.applyLinearImpulse(velocity*dt);
    body.applyAngularImpulse(3);

    if (horizontalDirection < 0 && player2.scale.x > 0) {
      //flipAxisDirection(AxisDirection.left);
      //flipAxis(Axis.horizontal);
      player2.flipHorizontallyAroundCenter();
    } else if (horizontalDirection > 0 && player2.scale.x < 0) {
      //flipAxisDirection(AxisDirection.left);
      player2.flipHorizontallyAroundCenter();
    }

    if (position.x < -size.x || game.healthP2 <= 0) {
      game.setDirection(0,0);
      removeFromParent();

    }

    super.update(dt);
  }

  void destruir(){
    removeFromParent();
  }

}

class Player2 extends SpriteAnimationComponent with HasGameRef<MapaJuego>, CollisionCallbacks {
  Player2({
    required super.position,
  }) : super(anchor: Anchor.center);





  late CircleHitbox hitbox;

  bool hitByEnemy = false;

  @override
  Future<void> onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('ember.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2(16,16),
        stepTime: 0.12,
      ),
    );

    //hitbox=CircleHitbox();

    //add(hitbox);
  }



  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    print("DEBUG: COLLISION!!!!!!! ");

    if (other is Star) {
      other.removeFromParent();
      game.starsCollected++;
    }

    if (other is GotaBody) {
      hit();
    }

    super.onCollision(intersectionPoints, other);
  }

  void hit() {
    if (!hitByEnemy) {
      hitByEnemy = true;
      game.healthP2--;
      add(
        OpacityEffect.fadeOut(
          EffectController(
            alternate: true,
            duration: 0.1,
            repeatCount: 6,
          ),
        )..onComplete = () {
          hitByEnemy = false;
        },
      );

    }
  }
}