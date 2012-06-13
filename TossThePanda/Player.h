//
//  Player.h
//  TossThePanda
//
//  Created by Manpreet on 6/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "CCBox2D.h"

@interface Player : CCBodySprite <CCTargetedTouchDelegate> {
    
    CCAction *rotationAction;
    CGPoint startingPoint;
    
    int deltaX;
    int deltaY;
    int x0;
    int y0;
    
    BOOL _isRotating;
    BOOL _isFlying;
    BOOL _isLaunched;
}

@property (nonatomic) CGPoint startingPoint;
@property (nonatomic) BOOL isRotating;
@property (nonatomic) BOOL isFlying;
@property (nonatomic) BOOL isLaunched;

+ (id) initWithFileName: (NSString *)file;

- (void) rotateMe;
- (void) stopRotatingMe;
- (void) checkIfPlayerStops:(int)floorY;

@end
