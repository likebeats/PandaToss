//
//  Animation.mm
//  TossThePanda
//
//  Created by Manpreet on 6/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Types.h"
#import "Animation.h"

@implementation Animation

@synthesize batchnode = _batchnode;
@synthesize sprite = _sprite;

+ (id) newAnimation: (NSString *)file 
           Position: (CGPoint)position 
          DelayTime: (float)delayTime 
        TotalFrames: (int)totalFrames 
          SheetRows: (int)sheetRows 
       SheetColumns: (int)sheetColumns 
         FrameWidth: (float)frameWidth 
        FrameHeight: (float)frameHeight 
      RepeatForever: (BOOL)repeat
{
    return [[[self alloc] initAnimation:file 
                               Position:position 
                              DelayTime:delayTime 
                            TotalFrames:totalFrames 
                              SheetRows:sheetRows 
                           SheetColumns:sheetColumns 
                             FrameWidth:frameWidth 
                            FrameHeight:frameHeight 
                          RepeatForever:repeat 
                                  World:nil 
                            PhysicsType:kStatic
                                BoxName:nil 
                                BoxSize:CGSizeZero
                          CollisionType:nil 
                       CollidesWithType:0 ] autorelease];
}

+ (id) newAnimationWithBody: (NSString *)file 
                   Position: (CGPoint)position 
                  DelayTime: (float)delayTime 
                TotalFrames: (int)totalFrames 
                  SheetRows: (int)sheetRows 
               SheetColumns: (int)sheetColumns 
                 FrameWidth: (float)frameWidth 
                FrameHeight: (float)frameHeight 
              RepeatForever: (BOOL)repeat 
                      World: (CCWorldLayer *)world 
                PhysicsType: (PhysicsType)physicsType 
                    BoxName: (NSString *)spriteBoxName 
                    BoxSize: (CGSize)spriteBoxSize 
              CollisionType: (uint16)collisionType 
           CollidesWithType: (uint16)collidesWithType
{
    return [[[self alloc] initAnimation:file 
                               Position:position 
                              DelayTime:delayTime 
                            TotalFrames:totalFrames 
                              SheetRows:sheetRows 
                           SheetColumns:sheetColumns 
                             FrameWidth:frameWidth 
                            FrameHeight:frameHeight 
                          RepeatForever:repeat 
                                  World:world 
                            PhysicsType:physicsType 
                                BoxName:spriteBoxName 
                                BoxSize:spriteBoxSize 
                          CollisionType:collisionType 
                       CollidesWithType:collidesWithType ] autorelease];
}

- (id) initAnimation: (NSString *)file 
            Position: (CGPoint)position
           DelayTime: (float)delayTime
         TotalFrames: (int)totalFrames
           SheetRows: (int)sheetRows
        SheetColumns: (int)sheetColumns
          FrameWidth: (float)frameWidth
         FrameHeight: (float)frameHeight 
       RepeatForever: (BOOL)repeat 
               World: (CCWorldLayer *)world 
         PhysicsType: (PhysicsType)physicsType 
             BoxName: (NSString *)spriteBoxName 
             BoxSize: (CGSize)spriteBoxSize 
       CollisionType: (uint16)collisionType 
    CollidesWithType: (uint16)collidesWithType
{
	if( (self=[super init]) ) {
        
        self.batchnode = [CCSpriteBatchNode batchNodeWithFile:file];
        self.sprite = [CCBodySprite spriteWithTexture:self.batchnode.texture rect:CGRectMake(0, 0, frameWidth, frameHeight)];
        
        if (world != nil) {
            self.sprite.world = world;
            self.sprite.physicsType = physicsType;
            self.sprite.collisionType = collisionType;
            self.sprite.collidesWithType = collidesWithType;
            self.sprite.density = 0.0f;
            self.sprite.friction = 0.0f;
            self.sprite.bounce = 0.0f;
            [self.sprite addBoxWithName:spriteBoxName ofSize:spriteBoxSize];
        }
        
        self.sprite.position = position;
        
        CCAnimation *animation = [CCAnimation animation];
        [animation setDelay:delayTime];
        
        int frameCount = 0;
        for (int y = 0; y < sheetRows; y++) {          // num of rows
            for (int x = 0; x < sheetColumns; x++) {   // num of columns
                CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:self.batchnode.texture rect:CGRectMake(x*frameWidth,y*frameHeight,frameWidth,frameHeight)];
                [animation addFrame:frame];
                
                frameCount++;
                if (frameCount == totalFrames) break;
            }
        }
        
        if (repeat == YES) {
            id action = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation]];
            [self.sprite runAction:action];
        } else {
            id action = [CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO];
            [self.sprite runAction:[CCSequence actions:
                                    action,
                                    [CCCallFuncN actionWithTarget:self selector:@selector(removeAnimation)],
                                    nil]];
        }
        
        [self.batchnode addChild:self.sprite z:1];
        [self addChild:self.batchnode];
    }
    return self;
}

- (void) removeAnimation
{
    [self removeAllChildrenWithCleanup:YES];
}

- (void) onEnter
{
	[super onEnter];
}

- (void) onExit
{
	[super onExit];
}

- (void) dealloc
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
	[super dealloc];
}

@end
