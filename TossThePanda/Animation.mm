//
//  Animation.mm
//  TossThePanda
//
//  Created by Manpreet on 6/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Animation.h"

enum {
	kPlayerCollisionType = 1,
	kFloorCollisionType = 2,
    kFireCollisionType = 3
};

@implementation Animation

@synthesize world = _world;
@synthesize delayTime = _delayTime;
@synthesize totalFrames = _totalFrames;
@synthesize sheetRows = _sheetRows;
@synthesize sheetColumns = _sheetColumns;
@synthesize frameWidth = _frameWidth;
@synthesize frameHeight = _frameHeight;
@synthesize position = _position;
@synthesize spriteBoxSize = _spriteBoxSize;
@synthesize spriteBoxName = _spriteBoxName;

+ (id) initWithSpriteSheet: (NSString *)file
{
    return [self batchNodeWithFile:file];
}

- (void) onEnter
{
    CCBodySprite *fireSprite = [CCBodySprite spriteWithTexture:self.texture rect:CGRectMake(0, 0, self.frameWidth, self.frameHeight)];    
    fireSprite.world = self.world;
    fireSprite.physicsType = kStatic;
    fireSprite.collisionType = kFireCollisionType;
    fireSprite.collidesWithType = kPlayerCollisionType;
    fireSprite.position = self.position;
    fireSprite.density = 0.0f;
    fireSprite.friction = 0.0f;
    fireSprite.bounce = 0.0f;
    [fireSprite addBoxWithName:self.spriteBoxName ofSize:self.spriteBoxSize];
    
    CCAnimation *fireAnimation = [CCAnimation animation];
    [fireAnimation setDelay:self.delayTime];
    
    int frameCount = 0;
    for (int y = 0; y < self.sheetRows; y++) {       // num of rows
        for (int x = 0; x < self.sheetColumns; x++) {   // num of columns
            //CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:danceSheet.texture rect:CGRectMake(x*85,y*121,85,121) offset:ccp(0,0)];
            CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:self.texture rect:CGRectMake(x*self.frameWidth,y*self.frameHeight,self.frameWidth,self.frameHeight)];
            [fireAnimation addFrame:frame];
            
            frameCount++;
            if (frameCount == self.totalFrames) break;
        }
    }
    CCAction *flyAction = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:fireAnimation]];
    [fireSprite runAction:flyAction];
    [self addChild:fireSprite z:1];
    
	[super onEnter];
}

- (void) onExit
{
	[super onExit];
}

- (void) dealloc
{
	[super dealloc];
}

@end
