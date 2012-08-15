//
//  ShopExtraPanel.m
//  TossThePanda
//
//  Created by Manpreet on 8/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ShopExtraPanel.h"

@implementation ShopExtraPanel

+ (id) newExtraPanel:(int)i
{
    return [[self alloc] init:i];
}

- (id) init:(int)i
{
	if ((self=[super init])) {
        
        standardUserDefaults = [NSUserDefaults standardUserDefaults];
        
    }
    return self;
}

- (void) onEnter
{
	[super onEnter];
    
    CCSprite *panel = [CCSprite spriteWithSpriteFrameName:@"shop_panel.png"];
    
    [self addChild:panel];
}

@end
