//
//  GameScene.h
//  TossThePanda
//
//  Created by Manpreet on 6/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GlobalVars.h"
#import "cocos2d.h"

#import "GB2DebugDrawLayer.h"
#import "GB2Sprite.h"

#import "Player.h"
#import "Cannon.h"
#import "ScoreScene.h"

@interface GameScene : CCLayer
{
    NSUserDefaults * standardUserDefaults;
    CGSize screenSize;
    GlobalVars *globalVars;
    
    CCSpriteBatchNode *masterBatchNode;
    
    NSMutableArray *gradientsGroups;
    NSMutableArray *themeBgs;
    NSMutableArray *floors;
    CCArray *goodies;
    CCArray *baddies;
    
    Player *player;
    Cannon *cannon;
    CCNode *floorGroup;
    CCNode *bgGroup;
    
    int gunId;
    int gunPower;
    int gunAmmo;
    int gunAmmosLeft;
    
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
    ScoreScene *scoreScreen;
}

+(CCScene *) scene;

- (void) initScene;

@end
