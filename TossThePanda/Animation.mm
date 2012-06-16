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
@synthesize physicsType = _physicsType;
@synthesize collisionType = _collisionType;
@synthesize collidesWithType = _collidesWithType;

+ (id) initWithSpriteSheet: (NSString *)file
{
    return [self batchNodeWithFile:file];
}

- (void) onEnter
{
    CCBodySprite *sprite = [CCBodySprite spriteWithTexture:self.texture rect:CGRectMake(0, 0, self.frameWidth, self.frameHeight)];    
    sprite.world = self.world;
    sprite.physicsType = self.physicsType;
    sprite.collisionType = self.collisionType;
    sprite.collidesWithType = self.collidesWithType;
    sprite.position = self.position;
    sprite.density = 0.0f;
    sprite.friction = 0.0f;
    sprite.bounce = 0.0f;
    [sprite addBoxWithName:self.spriteBoxName ofSize:self.spriteBoxSize];
    
    CCAnimation *animation = [CCAnimation animation];
    [animation setDelay:self.delayTime];
    
    int frameCount = 0;
    for (int y = 0; y < self.sheetRows; y++) {       // num of rows
        for (int x = 0; x < self.sheetColumns; x++) {   // num of columns
            //CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:danceSheet.texture rect:CGRectMake(x*85,y*121,85,121) offset:ccp(0,0)];
            CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:self.texture rect:CGRectMake(x*self.frameWidth,y*self.frameHeight,self.frameWidth,self.frameHeight)];
            [animation addFrame:frame];
            
            frameCount++;
            if (frameCount == self.totalFrames) break;
        }
    }
    CCAction *action = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation]];
    [sprite runAction:action];
    [self addChild:sprite z:1];
    
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
