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
    
    BOOL _isFlying;
    
}

@property (nonatomic) BOOL isFlying;

+ (id) initWithFileName: (NSString *)file;

- (CGPoint) getStartingPoint;
- (void) rotateMe;
- (void) stopRotatingMe;
- (void) checkifPlayerStops:(int)floorY;

@end
