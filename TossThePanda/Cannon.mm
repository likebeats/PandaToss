//
//  Cannon.mm
//  TossThePanda
//
//  Created by Manpreet on 6/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Cannon.h"

@implementation Cannon

@synthesize body = _body;
@synthesize mouth = _mouth;
@synthesize power = _power;
@synthesize playerOffset = _playerOffset;

+ (id) cannonWithName: (NSString *)name StartingPosition: (CGPoint)point
{
    return [[[self alloc] initCannonWithName:name StartingPosition:point] autorelease];
}

- (id) initCannonWithName: (NSString *)name StartingPosition: (CGPoint)point
{
	if ((self=[super init])) {
        
        CGPoint mouthAnchor;
        CGPoint bodyPosition;
        int mouthOffsetX;
        int mouthOffsetY;
        if ([name isEqualToString:@"wood"]) {
            mouthAnchor = ccp(0.3,0.5);
            bodyPosition = ccp(-30,-20);
            mouthOffsetX = 20;
            mouthOffsetY = 10;
            self.playerOffset = ccp(30,20);
            self.power = 27;
        } else if ([name isEqualToString:@"metal"]) {
            mouthAnchor = ccp(0.3,0.5);
            bodyPosition = ccp(-30,-20);
            mouthOffsetX = 25;
            mouthOffsetY = 18;
            self.playerOffset = ccp(50,50);
            self.power = 48;
        } else if ([name isEqualToString:@"gold"]) {
            mouthAnchor = ccp(0.1,0.5);
            bodyPosition = ccp(-30,-20);
            mouthOffsetX = 5;
            mouthOffsetY = 14;
            self.playerOffset = ccp(100,140);
            self.power = 100;
        } else if ([name isEqualToString:@"tank"]) {
            mouthAnchor = ccp(0.1,0.5);
            bodyPosition = ccp(-30,-20);
            mouthOffsetX = 12;
            mouthOffsetY = 20;
            self.playerOffset = ccp(100,130);
            self.power = 1000000000*100;
        }
        
        self.body = [CCSprite spriteWithFile:[name stringByAppendingString:@"_cannon_body.png"]];
        self.mouth = [CCSprite spriteWithFile:[name stringByAppendingString:@"_cannon_mouth.png"]];
        self.mouth.anchorPoint = mouthAnchor;
        self.body.position = bodyPosition;
        self.mouth.position = ccp(self.body.position.x+mouthOffsetX,self.body.position.y+mouthOffsetY);
        
        [self addChild:self.mouth];
        [self addChild:self.body];
        
    }
    return self;
}

- (void) rotateMouth: (float)degree
{
    self.mouth.rotation = MAX(MIN(degree, 0), -80);
}

- (void) dealloc
{
	[super dealloc];
}

@end
