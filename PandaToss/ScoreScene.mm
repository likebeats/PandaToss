//
//  ScoreScene.m
//  TossThePanda
//
//  Created by Manpreet on 7/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ScoreScene.h"
#import "Menu.h"
#import "GameScene.h"
#import "Shop.h"

@implementation ScoreScene

- (id)init
{
	if( (self=[super init])) {
        
        screenSize = [CCDirector sharedDirector].winSize;
        screenSizeInPixels = [CCDirector sharedDirector].winSizeInPixels;
		
        [self initScene];
        
    }
    return self;
}

- (void) initScene
{
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"score_screen_panel.png"];
    sprite.anchorPoint = ccp(0,1);
    sprite.position = ccp(13,screenSize.height);
    [self addChild:sprite z:1];
    
    CCMenuItem *menuBtn = [CCMenuItemFont itemWithString: @"Menu" target: self selector:@selector(openMenu)];
    CCMenuItem *retryBtn = [CCMenuItemFont itemWithString: @"Retry" target: self selector:@selector(retry)];
    CCMenuItem *shopBtn = [CCMenuItemFont itemWithString: @"Shop" target: self selector:@selector(openShop)];
    CCMenu *menu = [CCMenu menuWithItems:menuBtn, retryBtn, shopBtn, nil];
    menu.position = ccp(screenSize.width/2,screenSize.height/2);
    [menu alignItemsHorizontally];
    [self addChild:menu z:1];
}

- (void) openMenu
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[Menu scene]]];
}

- (void) retry
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameScene scene]]];
}

- (void) openShop
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[Shop scene]]];
}

- (void) onTransitionFinish
{
    self.isTouchEnabled = YES;
}

- (void) ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSLog(@"touch began - score screen");
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch ended - score screen");
}

@end
