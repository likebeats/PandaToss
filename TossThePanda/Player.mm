//
//  Player.mm
//  TossThePanda
//
//  Created by Manpreet on 6/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"

enum {
	kBoxCollisionType = 1,
	kWallCollisionType = 2
};

@implementation Player

@synthesize isRotating = _isRotating;
@synthesize isFlying = _isFlying;
@synthesize isLaunched = _isLaunched;

- (CGRect) rectInPixels
{
	CGSize s = [texture_ contentSizeInPixels];
	return CGRectMake(-s.width / 2, -s.height / 2, s.width, s.height);
}

+ (id) initWithFileName: (NSString *)file
{
    return [self spriteWithFile:file];
}

-(id) init
{
	if( (self=[super init]) ) {
        x0 = 0;
        y0 = 0;
        
        startingPoint = ccp(300,100);
        self.physicsType = kDynamic;
        self.collisionType = kBoxCollisionType;
        self.collidesWithType = kBoxCollisionType | kWallCollisionType;
        self.position = startingPoint;
        self.density = 3.0f;
        self.friction = 1.0f;
        self.bounce = 0.70f;
        [self addCircleWithName:@"player" ofRadius:10.0f];
    }
    return self;
}

- (CGPoint) getStartingPoint
{
    return startingPoint;
}

- (void) rotateMe
{
    rotationAction = [self runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:0.02 angle:5]]];
    self.isRotating = YES;
}

- (void) stopRotatingMe
{
    self.isRotating = NO;
    [rotationAction stop];
    rotationAction = nil;
}

- (void) checkIfPlayerStops:(int)floorY
{
    if (x0 != 0 && x0 != 0) {
        deltaX = abs(self.position.x - x0);
        deltaY = abs(self.position.y - y0);
    }
    x0 = self.position.x;
    y0 = self.position.y;

    float vx = self.velocity.x;
    float vy = self.velocity.y;
    
    if (self.isFlying == YES) {
        //NSLog(@"vx:%f vy:%f deltaX:%i deltaY:%i %f", vx, vy, deltaX, deltaY, (self.position.y - floorY));
        if (((self.position.y - floorY) < 49) && (abs(vy) < 10)) {
            self.velocity = ccp(vx - (vx*0.01), vy);
            if (deltaX <= 1 && deltaY < 1 && (abs(vx) < 5) && (abs(vy) < 2)) {
                self.isFlying = NO;
            }
        }
    } else {
        if (self.isLaunched == YES) {
            if (abs(vx) < 0.4 && abs(vy) < 0.4) {
                if (self.isRotating) [self stopRotatingMe];
                self.velocity = ccp(0,0);
            } else {
                self.velocity = ccp(vx*0.9, vy);
            }
        }
    }
}

- (void) onEnter
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}

- (void) onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}

- (BOOL) containsTouchLocation:(UITouch *)touch
{
	CGPoint p = [self convertTouchToNodeSpaceAR:touch];
	CGRect r = [self rectInPixels];
	return CGRectContainsPoint(r, p);
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ( ![self containsTouchLocation:touch] ) return NO;
	return YES;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    //self.position = ccp(touchPoint.x, touchPoint.y);
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"player sdfsffsfsdfd");
}

- (void) dealloc
{
	[super dealloc];
}

@end
