//
//  GameScene.h
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
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
    CCLabelTTF *velocityValue;
}

+(CCScene *) scene;

-(void)initScene;
-(void)repositionFloors;
-(void)repositionThemeBgs;

@end
