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
    return [[[self alloc] init:i] autorelease];
}

- (id) init:(int)i
{
	if ((self=[super init])) {
        
        standardUserDefaults = [NSUserDefaults standardUserDefaults];
        
        index = i;
        
    }
    return self;
}

- (void) onEnter
{
	[super onEnter];
    
    int gunEquipped = [standardUserDefaults integerForKey:@"gunId"];
    
    RoundedRectNode *panel = [RoundedRectNode newRectWithSize:self.contentSize];
    panel.borderWidth = 2.5;
    panel.position = ccp(-self.contentSize.width/2,self.contentSize.height/2);
    panel.color = ccc4(235, 241, 199, 255*0.7);
    panel.borderColor = ccc4(167, 172, 135, 255*0.7);
    panel.radius = 5;
    panel.cornerSegments = 5;
    
    CCLabelTTF *gun_title_lbl = [CCLabelTTF labelWithString:gunName fontName:@"Papyrus" fontSize: 18];
    CCSprite *gun_sprite = [CCSprite spriteWithFile:gunFileName];
    
    gun_title_lbl.color = ccc3(93, 154, 21);
    gun_title_lbl.position = ccp(0,24);
    gun_sprite.position = ccp(0,-10);
    
    equipped_lbl = [CCLabelTTF labelWithString:@"EQUIPPED" fontName:@"Chalkduster" fontSize: 10];
    equipped_lbl.position = ccp(35,-35);
    equipped_lbl.visible = NO;
    equipped_lbl.color = ccc3(93, 154, 21);
    if (gunEquipped == index) {
        equipped_lbl.visible = YES;
    }
    
    [self addChild:panel];
    [self addChild:gun_title_lbl];
    [self addChild:gun_sprite];
    [self addChild:equipped_lbl];
}

- (void) dealloc
{
	[super dealloc];
}

@end
