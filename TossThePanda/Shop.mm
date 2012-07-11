//
//  Menu.m
//  TossThePanda
//
//  Created by Manpreet on 7/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Shop.h"
#import "GameScene.h"

@implementation Shop

+ (CCScene*)scene
{
	CCScene *scene = [CCScene node];
	Shop *layer = [Shop node];
	[scene addChild: layer];
	return scene;
}

- (id)init
{
	if( (self=[super init])) {
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = NO;
        
        screenSize = [CCDirector sharedDirector].winSize;
        screenSizeInPixels = [CCDirector sharedDirector].winSizeInPixels;
		
        [self initScene];
	}
	return self;
}

- (void)initScene
{
    CCLabelTTF *title = [CCLabelTTF labelWithString:@"Shop" fontName:@"Chalkduster" fontSize: 26];
    [title setPosition:ccp(screenSize.width/2,screenSize.height-40)];
    [title setColor:ccc3(255,255,255)];
    [self addChild:title];
    
    CCMenuItem *startGameBtn = [CCMenuItemFont itemFromString: @"Retry" target: self selector:@selector(startGame)];
    CCMenu *menu = [CCMenu menuWithItems:startGameBtn, nil];
    menu.position = ccp(screenSize.width/2,screenSize.height/2);
    [self addChild:menu z:1];
}

- (void) startGame
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameScene scene]]];
}

- (void) dealloc
{
	[super dealloc];
}

@end
