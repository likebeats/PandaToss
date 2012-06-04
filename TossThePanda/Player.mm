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

@synthesize isFlying = _isFlying;

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
        startingPoint = ccp(300,100);
        self.physicsType = kDynamic;
        self.collisionType = kBoxCollisionType;
        self.collidesWithType = kBoxCollisionType | kWallCollisionType;
        self.position = startingPoint;
        self.density = 1.0f;
        self.friction = 1.0f;
        self.bounce = 0.0f;
        [self addCircleWithName:@"player" ofRadius:10.0f];
    }
    return self;
}

- (void) rotateMe
{
    rotationAction = [self runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:2.0 angle:360]]];
}

- (void) stopRotatingMe
{
    [rotationAction stop];
}

- (CGPoint) getStartingPoint
{
    return startingPoint;
}

- (void) checkifPlayerStops:(int)floorY
{
    if (x0 != 0 && x0 != 0) {
        deltaX = abs(self.position.x - x0);
        deltaY = abs(self.position.y - y0);
    }
    x0 = self.position.x;
    y0 = self.position.y;
    
    int vx = self.velocity.x;
    int vy = self.velocity.y;
    
    if (self.isFlying == YES) {
        NSLog(@"%i %i %f",deltaX, deltaY,(self.position.y - floorY));
        
        if (deltaX <= 2 && deltaY < 0.2 && (self.position.y - floorY) < 49) {
            NSLog(@"1");
            self.isFlying = NO;
        }
        if ((floorY - self.position.y < -40) && (abs(self.velocity.y) < 10)) {
            NSLog(@"2");
            self.velocity = ccp(vx - (vx*0.01), 0);
        }
        if (vx < 35) {
            //NSLog(@"3");
            self.velocity = ccp(vx+35, vy*0.9);
        }
    } else {
        NSLog(@"4");
        self.velocity = ccp(vx*0.9, vy);
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
