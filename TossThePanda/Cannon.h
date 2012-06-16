//
//  Cannon.h
//  TossThePanda
//
//  Created by Manpreet on 6/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface Cannon : CCNode {
    
    CCSprite *body;
    CCSprite *mouth;
    
    float power;
    CGPoint playerOffset;
}

@property (nonatomic, assign) CCSprite *body;
@property (nonatomic, assign) CCSprite *mouth;
@property (nonatomic) float power;
@property (nonatomic) CGPoint playerOffset;

+ (id) cannonWithName: (NSString *)name StartingPosition: (CGPoint)point;
- (id) initCannonWithName: (NSString *)name StartingPosition: (CGPoint)point;

- (void) rotateMouth: (float)degree;

@end
