//
//  ShopGunPanel.m
//  TossThePanda
//
//  Created by Manpreet on 8/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ShopGunPanel.h"

@implementation ShopGunPanel

@synthesize equipped_lbl, gunName, gunFileName;

+ (id) newGunPanel:(int)i
{
    return [[self alloc] init:i];
}

- (id) init:(int)i
{
	if ((self=[super init])) {
        
        standardUserDefaults = [NSUserDefaults standardUserDefaults];
        
        gunIndex = i;
        
    }
    return self;
}

- (void) onEnter
{
	[super onEnter];
    
    int gunEquipped = [standardUserDefaults integerForKey:@"gunId"];
    
    CCSprite *panel = [CCSprite spriteWithSpriteFrameName:@"shop_panel.png"];
    
    CCLabelTTF *gun_title_lbl = [CCLabelTTF labelWithString:gunName fontName:@"Papyrus" fontSize: 18];
    CCSprite *gun_sprite = [CCSprite spriteWithSpriteFrameName:gunFileName];
    
    gun_title_lbl.color = ccc3(93, 154, 21);
    gun_title_lbl.position = ccp(0,24);
    gun_sprite.position = ccp(0,-10);
    
    equipped_lbl = [CCLabelTTF labelWithString:@"EQUIPPED" fontName:@"Chalkduster" fontSize: 10];
    equipped_lbl.position = ccp(35,-35);
    equipped_lbl.visible = NO;
    equipped_lbl.color = ccc3(93, 154, 21);
    if (gunEquipped == gunIndex) {
        equipped_lbl.visible = YES;
    }
    
    [self addChild:panel];
    [self addChild:gun_title_lbl];
    [self addChild:gun_sprite];
    [self addChild:equipped_lbl];
}

@end
