import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum PlayerState { idle, running }

enum PlayerDirection { left, right, none }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure> {
  String character;
  Player({position, required this.character}) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.05;
  
  PlayerDirection playerDirection = PlayerDirection.left;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }
  
  
  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
    runningAnimation = _spriteAnimation('Run', 12);

    // List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
    };

    // Set current animation
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }
  
  void _updatePlayerMovement(double dt){
      double dx = 0.0;
      switch(playerDirection){
          case PlayerDirection.left:
            if(isFacingRight){
                flipHorizontallyAroundCenter();
                isFacingRight = false;
            }
            current = PlayerState.running;
            dx -= moveSpeed;
            break;
          case PlayerDirection.right:
            current = PlayerState.running;          
            dx += moveSpeed;
            break;
          case PlayerDirection.none:
            current = PlayerState.idle;
            break;
          default:
      }
      
      velocity = Vector2(dx,0.0);
      position += velocity * dt;
  }
}