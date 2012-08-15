//
//  ShopCannonPanel.m
//  TossThePanda
//
//  Created by Manpreet on 8/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ShopCannonPanel.h"

@implementation ShopCannonPanel

@synthesize equipped_lbl, cannonName, cannonFileName;

+ (id) newCannonPanel:(int)i
{
    return [[self alloc] init:i];
}

- (id) init:(int)i
{
	if ((self=[super init])) {
        
        standardUserDefaults = [NSUserDefaults standardUserDefaults];
        
        cannonIndex = i;
        
    }
    return self;
}

- (void) onEnter
{
	[super onEnter];
    
    int cannonEquipped = [standardUserDefaults integerForKey:@"cannonId"];
    
    CCSprite *panel = [CCSprite spriteWithSpriteFrameName:@"shop_panel.png"];
    
    CCLabelTTF *cannon_title_lbl = [CCLabelTTF labelWithString:cannonName fontName:@"Papyrus" fontSize: 18];
    //CCSprite *cannon_sprite = [CCSprite spriteWithFile:cannonFileName];
    
    cannon_title_lbl.color = ccc3(93, 154, 21);
    cannon_title_lbl.position = ccp(0,24);
    //cannon_sprite.position = ccp(0,-10);
    
    equipped_lbl = [CCLabelTTF labelWithString:@"EQUIPPED" fontName:@"Chalkduster" fontSize: 10];
    equipped_lbl.position = ccp(35,-35);
    equipped_lbl.visible = NO;
    equipped_lbl.color = ccc3(93, 154, 21);
    if (cannonEquipped == cannonIndex) {
        equipped_lbl.visible = YES;
    }
    
    [self addChild:panel];
    [self addChild:cannon_title_lbl];
    //[self addChild:cannon_sprite];
    [self addChild:equipped_lbl];
}

@end
