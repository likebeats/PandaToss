//
//  Player.mm
//  TossThePanda
//
//  Created by Manpreet on 6/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Types.h"
#import "Player.h"

@implementation Player

@synthesize startingPoint = _startingPoint;
@synthesize isRotating = _isRotating;
@synthesize isFlying = _isFlying;
@synthesize isLaunched = _isLaunched;
@synthesize isOnFire = _isOnFire;
@synthesize flame = _flame;

- (CGRect) rectInPixels
{
	CGSize s = [texture_ contentSizeInPixels];
	return CGRectMake(-s.width / 2, -s.height / 2, s.width, s.height);
}

+ (id) newPlayer
{
    return [self spriteWithFile:@"panda3.png"];
}

- (id) init
{
	if ((self=[super init])) {
        CGSize screensize = [CCDirector sharedDirector].winSize;
        x0 = 0;
        y0 = 0;
        flameTimerMax = 300.0;
        flameTimer = 0.0;
        isFlameFadding = NO;
        self.isOnFire = NO;
        self.flame = nil;
        
        self.startingPoint = ccp(screensize.width/2,100);
        self.physicsType = kStatic;
        self.collisionType = kPlayerCollisionType;
        self.collidesWithType = kFloorCollisionType | kFireCollisionType;
        self.position = self.startingPoint;
        self.density = 3.0f;
        self.friction = 1.0f;
        self.bounce = 0.70f;
        self.visible = NO;
        [self addCircleWithName:@"player" ofRadius:10.0f];
        
        startAngle = [self rotation];
        angleTime = 0;
    }
    return self;
}

- (void) controlRotating: (ccTime)dt
{
    if (self.isRotating == YES) {
        angleTime = angleTime + dt;
        [self setRotation: (startAngle + 100 * angleTime )];
    }
}

- (void) rotateMe
{
    self.isRotating = YES;
}

- (void) stopRotatingMe
{
    self.isRotating = NO;
}

- (BOOL) checkIfPlayerStops:(int)floorY
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
        if (((self.position.y - floorY) < 19) && (abs(vy) < 10)) {
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
                return YES;
            } else {
                self.velocity = ccp(vx*0.9, vy);
            }
        }
    }
    return NO;
}

- (void) putPlayerOnFire
{
    if (self.isOnFire == NO) {
        self.flame = [Animation newAnimation:@"fire_blast.png" 
                                    Position:self.position 
                                   DelayTime:0.5 
                                 TotalFrames:2 
                                   SheetRows:2 
                                SheetColumns:1 
                                  FrameWidth:180 
                                 FrameHeight:76.5 
                               RepeatForever:YES];
        self.flame.sprite.anchorPoint = ccp(0.8,0.5);
        self.isOnFire = YES;
    }
}

- (void) controlPlayerFire
{
    if (self.isOnFire == YES) {
        self.flame.sprite.position = self.position;
        self.flame.sprite.rotation = CC_RADIANS_TO_DEGREES(atan2(self.velocity.x, self.velocity.y))-90;
        if (flameTimer < flameTimerMax and isFlameFadding == NO) {
            flameTimer++;
        } else {
            isFlameFadding = YES;
            flameTimer--;
            float ratio = (flameTimer / flameTimerMax)*255;
            if (ratio < 0) {
                [self removeFlame];
            } else {
                self.flame.sprite.opacity = ratio;
            }
        }
    }
}

- (void) resetFlameTimer
{
    flameTimer = 0.0;
    isFlameFadding = NO;
    self.flame.sprite.opacity = 255.0;
}

- (void) removeFlame
{
    self.flame.sprite.opacity = 0;
    self.isOnFire = NO;
    isFlameFadding = NO;
    flameTimer = 0;
    [self.flame removeAnimation];
}

- (void) onEnter
{
    [self addTouch];
	[super onEnter];
}

- (void) onExit
{
	[self removeTouch];
	[super onExit];
}

- (void) addTouch
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (void) removeTouch
{
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
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
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"Player was touched!");
}

- (void) dealloc
{
	[super dealloc];
}

@end
