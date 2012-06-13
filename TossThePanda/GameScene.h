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

@interface GameScene : CCWorldLayer
{
    CGSize screenSize;
    CGSize screenSizeInPixels;
    
    NSMutableArray *gradientsGroups;
    NSMutableArray *themeBgs;
    NSMutableArray *floors;
    
    Player *player;
    Cannon *cannon;
    CCNode *floorGroup;
    CCNode *bgGroup;
    
    float fallLine;
    
    CCLabelTTF *powerValue;
    CCLabelTTF *distanceValue;
    CCLabelTTF *heightValue;
    CCLabelTTF *velocityValue;
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
- (void) rotateCannonMouth: (CGPoint)touch;

@end
