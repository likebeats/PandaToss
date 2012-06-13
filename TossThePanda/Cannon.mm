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

+ (id) cannonWithName: (NSString *)name StartingPosition: (CGPoint)point
{
    return [[[self alloc] initCannonWithName:name StartingPosition:point] autorelease];
}

- (id) initCannonWithName: (NSString *)name StartingPosition: (CGPoint)point
{
	if ((self=[super init])) {
        
        self.body = [CCSprite spriteWithFile:[name stringByAppendingString:@"_cannon_body.png"]];
        self.mouth = [CCSprite spriteWithFile:[name stringByAppendingString:@"_cannon_mouth.png"]];
        self.mouth.anchorPoint = ccp(0.3,0.5);
        self.body.position = ccp(-30,-20);
        self.mouth.position = ccp(self.body.position.x+20,self.body.position.y+10);
        //cannonMouth.position = ccp(self.body.position.x+50,self.body.position.y+15);
        
        [self addChild:self.mouth];
        [self addChild:self.body];
        
    }
    return self;
}

- (void) rotateMouth: (float)degree
{
    self.mouth.rotation = MAX(MIN(degree, 0), -80);
}

@end
