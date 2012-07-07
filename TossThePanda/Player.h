//
//  Player.h
//  TossThePanda
//
//  Created by Manpreet on 6/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "CCBox2D.h"
#import "Animation.h"

@interface Player : CCBodySprite <CCTargetedTouchDelegate> {
    
    CCAction *rotationAction;
    CGPoint startingPoint;
    
    int deltaX;
    int deltaY;
    int x0;
    int y0;
    
    //flame
    Animation *flame;
    float flameTimerMax;
    float flameTimer;
    BOOL isFlameFadding;
    
    BOOL _isRotating;
    BOOL _isFlying;
    BOOL _isLaunched;
    BOOL _isOnFire;
}

@property (nonatomic) CGPoint startingPoint;
@property (nonatomic) BOOL isRotating;
@property (nonatomic) BOOL isFlying;
@property (nonatomic) BOOL isLaunched;
@property (nonatomic) BOOL isOnFire;
@property (nonatomic, assign) Animation *flame;

+ (id) newPlayer;

- (void) rotateMe;
- (void) stopRotatingMe;
- (BOOL) checkIfPlayerStops:(int)floorY;
- (void) putPlayerOnFire;
- (void) controlPlayerFire;
- (void) resetFlameTimer;
- (void) removeTouch;

@end
