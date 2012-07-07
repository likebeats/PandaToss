//
//  GameScene.h
//  TossThePanda
//
//  Created by Manpreet on 6/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "CCBox2D.h"

#import "Animation.h"
#import "Player.h"
#import "Cannon.h"
#import "ScoreScene.h"

@interface GameScene : CCWorldLayer
{
    CGSize screenSize;
    CGSize screenSizeInPixels;
    
    NSMutableArray *gradientsGroups;
    NSMutableArray *themeBgs;
    NSMutableArray *floors;
    CCArray *goodies;
    CCArray *baddies;
    
    Player *player;
    Cannon *cannon;
    CCNode *floorGroup;
    CCNode *bgGroup;
    
    float fallLine;
    
    CCLabelTTF *powerValue;
    CCLabelTTF *distanceValue;
    CCLabelTTF *heightValue;
    CCLabelTTF *velocityValue;
    
    int goodBall;
    int goodTime;
    int newGoodTime;
    int xnew;
    
    BOOL roundDone;
}

+(CCScene *) scene;

- (void) initScene;
- (void) createLabels;
- (void) enterFrame: (ccTime)dt;
- (void) moveCamera;
- (void) repositionFloors;
- (void) repositionGradientBgs;
- (void) repositionThemeBgs;
- (void) spawnGoodies;
- (void) spawnBaddies;
- (void) removeOffScreenObjects;
- (void) rotateCannonMouth: (CGPoint)touch;
- (void) openScoreScreen;

@end
