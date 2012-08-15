//
//  Animation.h
//  TossThePanda
//
//  Created by Manpreet on 6/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface Animation : CCNode {
    
    //CCSpriteBatchNode *batchnode;
    //CCBodySprite *sprite;
    
}

@property (nonatomic, assign) CCSpriteBatchNode *batchnode;
//@property (nonatomic, assign) CCBodySprite *sprite;

+ (id) newAnimation: (NSString *)file 
           Position: (CGPoint)position 
          DelayTime: (float)delayTime 
        TotalFrames: (int)totalFrames 
          SheetRows: (int)sheetRows 
       SheetColumns: (int)sheetColumns 
         FrameWidth: (float)frameWidth 
        FrameHeight: (float)frameHeight 
      RepeatForever: (BOOL)repeat;

/*+ (id) newAnimationWithBody: (NSString *)file
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
           CollidesWithType: (uint16)collidesWithType;*/

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
    CollidesWithType: (uint16)collidesWithType;

- (void) removeAnimation;

@end
