//
//  GameScene.h
//  TossThePanda
//
//  Created by Manpreet on 6/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
//#import "CCBox2D.h"

#import "GB2DebugDrawLayer.h"
#import "GB2Sprite.h"

//#import "Animation.h"
#import "Player.h"
#import "Cannon.h"
#import "ScoreScene.h"
//#import "Menu.h"
//#import "Shop.h"

@interface GameScene : CCLayer
{
    NSUserDefaults * standardUserDefaults;
    CGSize screenSize;
    CGSize screenSizeInPixels;
    
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
    //Menu *menuScreen;
}

+(CCScene *) scene;

- (void) initScene;
- (void) createGUI;
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
- (void) reset;
- (void) openScoreScreen;
- (void) stopGame;
- (void) setNextTheme;
- (void) onPlayerTouch;

@end
