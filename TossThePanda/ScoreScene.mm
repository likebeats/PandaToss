//
//  ScoreScene.m
//  TossThePanda
//
//  Created by Manpreet on 7/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Types.h"
#import "ScoreScene.h"

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

- (void) draw
{
    // do nothing
}

- (void) initScene
{
    CCSprite *sprite = [CCSprite spriteWithFile:@"score_screen_panel.png"];
    sprite.anchorPoint = ccp(0,1);
    sprite.position = ccp(13,screenSize.height);
    [self addChild:sprite z:1];
    
    CCMenuItem *retryBtn = [CCMenuItemFont itemFromString: @"Retry" target: self selector:@selector(retry)];
    CCMenu *menu = [CCMenu menuWithItems:retryBtn, nil];
    menu.position = ccp(screenSize.width/2,screenSize.height/2);
    [self addChild:menu z:1];
}

- (void) retry
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameScene scene]]];
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

- (void) dealloc
{
	[super dealloc];
}

@end
