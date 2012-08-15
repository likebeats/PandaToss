//
//  Menu.m
//  TossThePanda
//
//  Created by Manpreet on 7/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Menu.h"
#import "GameScene.h"

@implementation Menu

+ (CCScene*)scene
{
	CCScene *scene = [CCScene node];
	Menu *layer = [Menu node];
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
    CCSprite *bg = [CCSprite spriteWithSpriteFrameName:@"main_menu_bg.png"];
    [bg setPosition:ccp(screenSize.width/2, screenSize.height/2)];
    [self addChild:bg];
    
    CCSprite *btns_bg = [CCSprite spriteWithSpriteFrameName:@"main_menu_buttons.png"];
    [btns_bg setPosition:ccp(360, 170)];
    [self addChild:btns_bg];
    
    CCSprite *logo = [CCSprite spriteWithSpriteFrameName:@"logo.png"];
    [logo setPosition:ccp(370, 250)];
    [self addChild:logo];
    
    [CCMenuItemFont setFontSize:20];
    CCMenuItemFont *btn1 = [CCMenuItemFont itemWithString: @"Toss the Panda!" target: self selector:@selector(startGame)];
    CCMenuItemFont *btn2 = [CCMenuItemFont itemWithString: @"Options" target: self selector:@selector(startGame)];
    CCMenuItemFont *btn3 = [CCMenuItemFont itemWithString: @"About" target: self selector:@selector(startGame)];
    CCMenu *menu = [CCMenu menuWithItems:btn1, btn2, btn3, nil];
    [menu alignItemsVerticallyWithPadding:40];
    menu.position = ccp(360,120);
    [self addChild:menu z:1];
}

- (void) startGame
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameScene scene]]];
}

@end
