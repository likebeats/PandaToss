//
//  Animation.h
//  TossThePanda
//
//  Created by Manpreet on 6/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "CCBox2D.h"

@interface Animation : CCSpriteBatchNode {
    
}

@property (nonatomic, assign) CCWorldLayer *world;
@property (nonatomic) float delayTime;
@property (nonatomic) int totalFrames;
@property (nonatomic) int sheetRows;
@property (nonatomic) int sheetColumns;
@property (nonatomic) float frameWidth;
@property (nonatomic) float frameHeight;
@property (nonatomic) CGPoint position;
@property (nonatomic) CGSize spriteBoxSize;
@property (nonatomic, assign) NSString *spriteBoxName;
@property (nonatomic) PhysicsType physicsType;
@property (nonatomic) uint16 collisionType;
@property (nonatomic) uint16 collidesWithType;

+ (id) initWithSpriteSheet: (NSString *)file;

@end
