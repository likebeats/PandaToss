//
//  GameScene.h
//  TossThePanda
//
//  Created by Manpreet on 6/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "CCBox2D.h"

#import "Player.h"

@interface GameScene : CCWorldLayer
{
    CGSize screenSize;
    
    NSMutableArray *bgs;
    NSMutableArray *themeBgs;
    NSMutableArray *floors;
    
    Player *player;
    CCNode *floorGroup;
    CCNode *bgGroup;
    
    CCLabelTTF *powerValue;
    CCLabelTTF *distanceValue;
    CCLabelTTF *heightValue;
    CCLabelTTF *velocityValue;
}

+(CCScene *) scene;

-(void)initScene;
-(void)moveCamera;
-(void)repositionFloors;
-(void)repositionThemeBgs;

@end
