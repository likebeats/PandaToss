//
//  Player.h
//  TossThePanda
//
//  Created by Manpreet on 6/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "GB2Sprite.h"
//#import "Animation.h"

@interface Player : GB2Sprite <CCTargetedTouchDelegate> {
    
    CCAction *rotationAction;
    CGPoint startingPoint;
    
    int deltaX;
    int deltaY;
    int x0;
    int y0;
    float startAngle;
    float angleTime;
    float finalAngle;
    
    //flame
    //Animation *flame;
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
//@property (nonatomic, assign) Animation *flame;

+ (id) newPlayer;
- (id) initNewPlayer;

- (void) controlRotating: (ccTime)dt;
- (void) rotateMe;
- (void) stopRotatingMe;
- (BOOL) checkIfPlayerStops:(int)floorY;
- (void) putPlayerOnFire;
- (void) controlPlayerFire;
- (void) resetFlameTimer;
- (void) removeFlame;
- (void) addTouch;
- (void) removeTouch;

@end
