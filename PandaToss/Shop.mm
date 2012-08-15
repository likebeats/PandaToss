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
		
        standardUserDefaults = [NSUserDefaults standardUserDefaults];
        [standardUserDefaults synchronize];
        
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = NO;
        
        screenSize = [CCDirector sharedDirector].winSize;
		globalVars = [GlobalVars get];
        
        [self initScene];
	}
	return self;
}

- (void)initScene
{
    tab_open = 0;
    tab_animation_delta = 10;
    
    CCSprite *bg = [CCSprite spriteWithSpriteFrameName:@"shop_bg.png"];
    bg.position = ccp(screenSize.width/2, screenSize.height/2);
    [self addChild:bg];
    
    menu_item1 = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"shop_menu_item.png"] selectedSprite:nil target:self selector:@selector(openGuns)];
    menu_item2 = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"shop_menu_item.png"] selectedSprite:nil target:self selector:@selector(openCannons)];
    menu_item3 = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"shop_menu_item.png"] selectedSprite:nil target:self selector:@selector(openExtras)];
    
    tab_menu = [CCMenu menuWithItems:menu_item1, menu_item2, menu_item3, nil];
    [tab_menu alignItemsHorizontallyWithPadding:10];
    [self addChild:tab_menu];
    
    CCSprite *top_board = [CCSprite spriteWithSpriteFrameName:@"shop_top_board.png"];
    top_board.position = ccp(178,screenSize.height-33);
    [self addChild:top_board];
    
    tab_menu.position = ccp(top_board.position.x,top_board.position.y-23);
    
    CCLabelTTF *title = [CCLabelTTF labelWithString:@"Shop" fontName:@"Chalkduster" fontSize: 18];
    [title setPosition:ccp(top_board.position.x, top_board.position.y)];
    [title setColor:ccc3(255,255,255)];
    [self addChild:title z:1];
    
    menu_item1_lbl = [CCLabelTTF labelWithString:@"Guns" fontName:@"Chalkduster" fontSize: 12];
    menu_item2_lbl = [CCLabelTTF labelWithString:@"Cannons" fontName:@"Chalkduster" fontSize: 12];
    menu_item3_lbl = [CCLabelTTF labelWithString:@"Extras" fontName:@"Chalkduster" fontSize: 12];
    [menu_item1_lbl setPosition:ccp(78, top_board.position.y-43)];
    [menu_item2_lbl setPosition:ccp(menu_item1_lbl.position.x+100, top_board.position.y-43)];
    [menu_item3_lbl setPosition:ccp(menu_item2_lbl.position.x+100, top_board.position.y-43)];
    [menu_item1_lbl setColor:ccc3(255,255,255)];
    [menu_item2_lbl setColor:ccc3(255,255,255)];
    [menu_item3_lbl setColor:ccc3(255,255,255)];
    [self addChild:menu_item1_lbl z:1];
    [self addChild:menu_item2_lbl z:1];
    [self addChild:menu_item3_lbl z:1];
    
    CCSprite *money_counter = [CCSprite spriteWithSpriteFrameName:@"shop_money_counter.png"];
    money_counter.position = ccp(screenSize.width-70,screenSize.height-42);
    [self addChild:money_counter];
    
    CCLabelTTF *bank_title = [CCLabelTTF labelWithString:@"Bank" fontName:@"Chalkduster" fontSize: 16];
    bank_title.position = ccp(money_counter.position.x, money_counter.position.y+10);
    [self addChild:bank_title];
    
    int bank = [standardUserDefaults integerForKey:@"bank"];
    bank_lbl = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"$%i", bank] fontName:@"Chalkduster" fontSize: 18];
    bank_lbl.position = ccp(money_counter.position.x, money_counter.position.y-16);
    [self addChild:bank_lbl];
    
    [CCMenuItemFont setFontSize: 26];
    CCMenuItemFont *retry_btn_item = [CCMenuItemFont itemWithString:@"< Toss the Panda" target:self selector:@selector(startGame)];
    retry_btn_item.color = ccc3(0,0,0);
    CCMenu *retry_btn = [CCMenu menuWithItems:retry_btn_item, nil];
    retry_btn.position = ccp(100,30);
    [self addChild:retry_btn];
    
    /* --------------------------  GUNS  ------------------------------------------  */
    gun_titles = globalVars.gunTitles;
    gun_file_names = globalVars.gunFileNames;
    
    gunEquipped = [standardUserDefaults integerForKey:@"gunId"];
    gunsOwned = [[NSMutableArray alloc] initWithArray:[standardUserDefaults objectForKey:@"gunsOwned"]];
    gun_panels = [[NSMutableArray alloc] initWithCapacity:[gun_titles count]];
    
    for (int i=0; i<[gun_titles count]; i++) {
        NSString *gun_title = [gun_titles objectAtIndex:i];
        NSString *gun_file_name = [gun_file_names objectAtIndex:i];
        
        ShopGunPanel *panelNode = [ShopGunPanel newGunPanel:i];
        panelNode.contentSize = CGSizeMake(142,88);
        panelNode.gunName = gun_title;
        panelNode.gunFileName = gun_file_name;
        
        [panelNode setOnClick:self selector:@selector(openGunDetails:data:) data:i];
        
        [gun_panels addObject:panelNode];
    }
    
    gunScrollMenu = [CCScrollMenu newScrollMenu:gun_panels padding:20];
    gunScrollMenu.position = ccp(10,90);
    [gunScrollMenu setOpacity:0];
    gunScrollMenu.visible = NO;
    gunScrollMenu.isTouchEnabled = NO;
    [self addChild:gunScrollMenu];
    /* --------------------------  END GUNS  --------------------------------------  */
    
    /* --------------------------  CANNONS   --------------------------------------  */
    cannon_titles = globalVars.cannonTitles;
    
    cannonEquipped = [standardUserDefaults integerForKey:@"cannonId"];
    cannonsOwned = [[NSMutableArray alloc] initWithArray:[standardUserDefaults objectForKey:@"cannonsOwned"]];
    cannon_panels = [[NSMutableArray alloc] initWithCapacity:[cannon_titles count]];
    
    for (int i=0; i<[cannon_titles count]; i++) {
        NSString *cannon_title = [cannon_titles objectAtIndex:i];
        //NSString *cannon_file_name = [cannon_file_names objectAtIndex:i];
        
        ShopCannonPanel *panelNode = [ShopCannonPanel newCannonPanel:i];
        panelNode.contentSize = CGSizeMake(142,88);
        panelNode.cannonName = cannon_title;
        
        [panelNode setOnClick:self selector:@selector(openCannonDetails:data:) data:i];
        
        [cannon_panels addObject:panelNode];
    }
    cannonScrollMenu = [CCScrollMenu newScrollMenu:cannon_panels padding:20];
    cannonScrollMenu.position = ccp(10,90);
    [cannonScrollMenu setOpacity:0];
    cannonScrollMenu.visible = NO;
    cannonScrollMenu.isTouchEnabled = NO;
    [self addChild:cannonScrollMenu];
    /* --------------------------  END CANNONS   ----------------------------------  */
    
    /* --------------------------  EXTRAS   ---------------------------------------  */
    extra_panels = [[NSMutableArray alloc] initWithCapacity:10];
    
    for (int i=0; i<10; i++) {
        ShopExtraPanel *panelNode = [ShopExtraPanel newExtraPanel:i];
        panelNode.contentSize = CGSizeMake(142,88);
        
        //[panelNode setOnClick:self selector:@selector(openCannonDetails:data:) data:i];
        
        [extra_panels addObject:panelNode];
    }
    extraScrollMenu = [CCScrollMenu newScrollMenu:extra_panels padding:20];
    extraScrollMenu.position = ccp(10,90);
    [extraScrollMenu setOpacity:0];
    extraScrollMenu.visible = NO;
    extraScrollMenu.isTouchEnabled = NO;
    [self addChild:extraScrollMenu];
    /* --------------------------  END EXTRAS   ----------------------------------  */
    
    [self openGuns];
}

- (void) disableTouchesForPopup
{
    tab_menu.isTouchEnabled = NO;
    if (tab_open == 1) {
        gunScrollMenu.isTouchEnabled = NO;
    } else if (tab_open == 2) {
        cannonScrollMenu.isTouchEnabled = NO;
    } else if (tab_open == 3) {
        extraScrollMenu.isTouchEnabled = NO;
    }
}

- (void) enableTouchesForPopup
{
    tab_menu.isTouchEnabled = YES;
    if (tab_open == 1) {
        gunScrollMenu.isTouchEnabled = YES;
    } else if (tab_open == 2) {
        cannonScrollMenu.isTouchEnabled = YES;
    } else if (tab_open == 3) {
        extraScrollMenu.isTouchEnabled = YES;
    }
}

- (BOOL) isGunOwned:(int)index
{
    NSNumber *result = [gunsOwned objectAtIndex:index];
    int check = [result integerValue];
    if (check == 1) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) buyGun:(int)index
{
    if (![self isGunOwned:index]) {
        NSLog(@"buying Gun");
        
        [gunsOwned replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger:1]];
        [standardUserDefaults setObject:gunsOwned forKey:@"gunsOwned"];
        
        return YES;
    } else {
        NSLog(@"Gun already bought");
        return NO;
    }
}

- (BOOL) equipGun:(int)index
{
    if ([self isGunOwned:index]) {
        NSLog(@"equipping");
        
        ShopGunPanel *oldPanel = [gun_panels objectAtIndex:gunEquipped];
        ShopGunPanel *newPanel = [gun_panels objectAtIndex:index];
        
        oldPanel.equipped_lbl.visible = NO;
        newPanel.equipped_lbl.visible = YES;
        
        gunEquipped = index;
        [standardUserDefaults setInteger:gunEquipped forKey:@"gunId"];
        
        return YES;
    } else {
        NSLog(@"gun not bought yet");
        return NO;
    }
}

- (void) openGunDetails:(id)sender data:(void*)callbackData
{
    [self disableTouchesForPopup];
    
    NSNumber *NSNumberIndex = (__bridge NSNumber*)callbackData;
    int index = [NSNumberIndex integerValue];
    
    gunDetailsPopup = [CCNode node];
    gunDetailsPopup.contentSize = CGSizeMake(350, 175);
    gunDetailsPopup.position = ccp(screenSize.width/2, screenSize.height/2-20);
    gunDetailsPopup.scale = 0;
    [self addChild:gunDetailsPopup z:2];
    
    CCSprite *popup_bg = [CCSprite spriteWithSpriteFrameName:@"shop_popup_bg.png"];
    popup_bg.position = ccp(0,10);
    [gunDetailsPopup addChild:popup_bg];
    
    [CCMenuItemFont setFontSize:24];
    CCMenuItemFont *close_btn_item = [CCMenuItemFont itemWithString:@"X" target:self selector:@selector(closeGunDetailsPopup)];
    close_btn_item.color = ccc3(93, 154, 21);
    CCMenu *close_btn = [CCMenu menuWithItems:close_btn_item, nil];
    close_btn.position = ccp(-150,75);
    [gunDetailsPopup addChild:close_btn];
    
    CCLabelTTF *gun_title = [CCLabelTTF labelWithString:[gun_titles objectAtIndex:index] fontName:@"Papyrus" fontSize: 28];
    gun_title.position = ccp(0,65);
    gun_title.color = ccc3(93, 154, 21);
    [gunDetailsPopup addChild:gun_title];
    
    /*RoundedRectNode *gun_bg = [RoundedRectNode newRectWithSize:CGSizeMake(160, 100)];
    gun_bg.borderWidth = 2.5;
    gun_bg.position = ccp(-160,40);
    gun_bg.color = ccc4(249, 241, 190, 255);
    gun_bg.borderColor = ccc4(169, 149, 61, 255);
    gun_bg.radius = 5;
    gun_bg.cornerSegments = 5;
    [gunDetailsPopup addChild:gun_bg];
    
    RoundedRectNode *gun_info_bg = [RoundedRectNode newRectWithSize:CGSizeMake(130, 60)];
    gun_info_bg.borderWidth = 2.5;
    gun_info_bg.position = ccp(15,40);
    gun_info_bg.color = ccc4(249, 241, 190, 255);
    gun_info_bg.borderColor = ccc4(169, 149, 61, 255);
    gun_info_bg.radius = 5;
    gun_info_bg.cornerSegments = 5;
    [gunDetailsPopup addChild:gun_info_bg];*/
    
    CCSprite *gun_sprite = [CCSprite spriteWithSpriteFrameName:[gun_file_names objectAtIndex:index]];
    gun_sprite.position = ccp(-80,-10);
    gun_sprite.scale = 1.5;
    [gunDetailsPopup addChild:gun_sprite];
    
    CCLabelTTF *gun_cost = [CCLabelTTF labelWithString:@"Cost: $0" fontName:@"Chalkduster" fontSize: 14];
    CCLabelTTF *gun_power = [CCLabelTTF labelWithString:@"Power: 0" fontName:@"Chalkduster" fontSize: 14];
    CCLabelTTF *gun_ammo = [CCLabelTTF labelWithString:@"Ammo: 0" fontName:@"Chalkduster" fontSize: 14];
    gun_cost.position = ccp(25,28);
    gun_power.position = ccp(gun_cost.position.x,gun_cost.position.y-18);
    gun_ammo.position = ccp(gun_cost.position.x,gun_power.position.y-18);
    gun_cost.color = ccDARKGOLDENROD;
    gun_power.color = ccDARKGOLDENROD;
    gun_ammo.color = ccDARKGOLDENROD;
    [gunDetailsPopup addChild:gun_cost];
    [gunDetailsPopup addChild:gun_power];
    [gunDetailsPopup addChild:gun_ammo];
    
    [CCMenuItemFont setFontSize:24];
    CCMenuItemFont *buy_btn_item = [CCMenuItemFont itemWithString:@"Buy" block:^(id sender) {
        [self buyGun:index];
    }];
    CCMenuItemFont *equip_btn_item = [CCMenuItemFont itemWithString:@"Equip" block:^(id sender) {
        [self equipGun:index];
    }];
    buy_btn_item.color = ccc3(0,0,0);
    equip_btn_item.color = ccc3(0,0,0);
    CCMenu *gun_options_menu = [CCMenu menuWithItems:buy_btn_item, equip_btn_item, nil];
    gun_options_menu.position = ccp(80,-45);
    [gun_options_menu alignItemsHorizontallyWithPadding:20];
    [gunDetailsPopup addChild:gun_options_menu];
    
    int cost = [[globalVars.gunCosts objectAtIndex:index] integerValue];
    int power = [[globalVars.gunPowers objectAtIndex:index] integerValue];
    int ammo = [[globalVars.gunAmmos objectAtIndex:index] integerValue];
    if (cost == 0) {
        gun_cost.string = @"Cost: FREE";
    } else {
        gun_cost.string = [NSString stringWithFormat:@"Cost: $%i", cost];
    }
    gun_power.string = [NSString stringWithFormat:@"Power: %i", power];
    gun_ammo.string = [NSString stringWithFormat:@"Ammo: %i", ammo];
    
    gun_cost.anchorPoint = ccp(0, 0.5);
    gun_power.anchorPoint = ccp(0, 0.5);
    gun_ammo.anchorPoint = ccp(0, 0.5);
    
    CCScaleTo *scale1 = [CCScaleTo actionWithDuration:0.2 scale:1.2];
    CCScaleTo *scale2 = [CCScaleTo actionWithDuration:0.3 scale:0.9];
    CCScaleTo *scale3 = [CCScaleTo actionWithDuration:0.3 scale:1];
    [gunDetailsPopup runAction:[CCSequence actions:scale1, scale2, scale3, nil]];
}

- (void) closeGunDetailsPopup
{
    [self enableTouchesForPopup];
    [gunDetailsPopup removeFromParentAndCleanup:YES];
    gunDetailsPopup = nil;
}

- (BOOL) isCannonOwned:(int)index
{
    NSNumber *result = [cannonsOwned objectAtIndex:index];
    int check = [result integerValue];
    if (check == 1) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) buyCannon:(int)index
{
    if (![self isCannonOwned:index]) {
        NSLog(@"buying Cannon");
        
        [cannonsOwned replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger:1]];
        [standardUserDefaults setObject:cannonsOwned forKey:@"cannonsOwned"];
        
        return YES;
    } else {
        NSLog(@"Cannon already bought");
        return NO;
    }
}

- (BOOL) equipCannon:(int)index
{
    if ([self isCannonOwned:index]) {
        NSLog(@"equipping");
        
        ShopCannonPanel *oldPanel = [cannon_panels objectAtIndex:cannonEquipped];
        ShopCannonPanel *newPanel = [cannon_panels objectAtIndex:index];
        
        oldPanel.equipped_lbl.visible = NO;
        newPanel.equipped_lbl.visible = YES;
        
        cannonEquipped = index;
        [standardUserDefaults setInteger:cannonEquipped forKey:@"cannonId"];
        
        return YES;
    } else {
        NSLog(@"cannon not bought yet");
        return NO;
    }
}

- (void) openCannonDetails:(id)sender data:(void*)callbackData
{
    [self disableTouchesForPopup];
    
    NSNumber *NSNumberIndex = (__bridge NSNumber*)callbackData;
    int index = [NSNumberIndex integerValue];
    
    cannonDetailsPopup = [CCNode node];
    cannonDetailsPopup.contentSize = CGSizeMake(350, 175);
    cannonDetailsPopup.position = ccp(screenSize.width/2, screenSize.height/2-20);
    cannonDetailsPopup.scale = 0;
    [self addChild:cannonDetailsPopup z:2];
    
    CCSprite *popup_bg = [CCSprite spriteWithSpriteFrameName:@"shop_popup_bg.png"];
    popup_bg.position = ccp(0,10);
    [cannonDetailsPopup addChild:popup_bg];
    
    CCLabelTTF *gun_title = [CCLabelTTF labelWithString:[cannon_titles objectAtIndex:index] fontName:@"Papyrus" fontSize: 28];
    gun_title.position = ccp(0,65);
    gun_title.color = ccc3(93, 154, 21);
    [cannonDetailsPopup addChild:gun_title];
    
    [CCMenuItemFont setFontSize:24];
    CCMenuItemFont *close_btn_item = [CCMenuItemFont itemWithString:@"X" target:self selector:@selector(closeCannonDetailsPopup)];
    close_btn_item.color = ccc3(93, 154, 21);
    CCMenu *close_btn = [CCMenu menuWithItems:close_btn_item, nil];
    close_btn.position = ccp(-150,75);
    [cannonDetailsPopup addChild:close_btn];
    
    CCLabelTTF *cannon_cost = [CCLabelTTF labelWithString:@"Cost: $0" fontName:@"Chalkduster" fontSize: 14];
    CCLabelTTF *cannon_power = [CCLabelTTF labelWithString:@"Power: 0" fontName:@"Chalkduster" fontSize: 14];
    cannon_cost.position = ccp(25,28);
    cannon_power.position = ccp(cannon_cost.position.x,cannon_cost.position.y-18);
    cannon_cost.color = ccDARKGOLDENROD;
    cannon_power.color = ccDARKGOLDENROD;
    [cannonDetailsPopup addChild:cannon_cost];
    [cannonDetailsPopup addChild:cannon_power];
    
    [CCMenuItemFont setFontSize:24];
    CCMenuItemFont *buy_btn_item = [CCMenuItemFont itemWithString:@"Buy" block:^(id sender) {
        [self buyCannon:index];
    }];
    CCMenuItemFont *equip_btn_item = [CCMenuItemFont itemWithString:@"Equip" block:^(id sender) {
        [self equipCannon:index];
    }];
    buy_btn_item.color = ccc3(0,0,0);
    equip_btn_item.color = ccc3(0,0,0);
    CCMenu *cannon_options_menu = [CCMenu menuWithItems:buy_btn_item, equip_btn_item, nil];
    cannon_options_menu.position = ccp(80,-45);
    [cannon_options_menu alignItemsHorizontallyWithPadding:20];
    [cannonDetailsPopup addChild:cannon_options_menu];
    
    int cost = [[globalVars.cannonCosts objectAtIndex:index] integerValue];
    int power = [[globalVars.cannonPowers objectAtIndex:index] integerValue];
    if (cost == 0) {
        cannon_cost.string = @"Cost: FREE";
    } else {
        cannon_cost.string = [NSString stringWithFormat:@"Cost: $%i", cost];
    }
    cannon_power.string = [NSString stringWithFormat:@"Power: %i", power];
    
    cannon_cost.anchorPoint = ccp(0, 0.5);
    cannon_power.anchorPoint = ccp(0, 0.5);
    
    CCScaleTo *scale1 = [CCScaleTo actionWithDuration:0.2 scale:1.2];
    CCScaleTo *scale2 = [CCScaleTo actionWithDuration:0.3 scale:0.9];
    CCScaleTo *scale3 = [CCScaleTo actionWithDuration:0.3 scale:1];
    [cannonDetailsPopup runAction:[CCSequence actions:scale1, scale2, scale3, nil]];
}

- (void) closeCannonDetailsPopup
{
    [self enableTouchesForPopup];
    [cannonDetailsPopup removeFromParentAndCleanup:YES];
    cannonDetailsPopup = nil;
}

- (void) openExtraDetails:(int)index
{
    [self disableTouchesForPopup];
    
    
}

- (void) closeExtraDetailsPopup
{
    [self enableTouchesForPopup];
    [extraDetailsPopup removeFromParentAndCleanup:YES];
    extraDetailsPopup = nil;
}

- (void) openGuns
{
    if (tab_open != 1) {
        [self closeOpenedTab];
        tab_open = 1;
        [menu_item1 runAction:[CCMoveBy actionWithDuration:0.1 position:ccp(0,-tab_animation_delta)]];
        [menu_item1_lbl runAction:[CCMoveBy actionWithDuration:0.1 position:ccp(0,-tab_animation_delta)]];
        gunScrollMenu.position = ccp(10,gunScrollMenu.contentSize.height+90);
        gunScrollMenu.visible = YES;
        [gunScrollMenu stopAllActions];
        [gunScrollMenu runAction:[CCFadeIn actionWithDuration:0.6]];
        [gunScrollMenu runAction:[CCMoveBy actionWithDuration:0.3 position:ccp(0,-gunScrollMenu.contentSize.height)]];
        gunScrollMenu.isTouchEnabled = YES;
    }
}

- (void) openCannons
{
    if (tab_open != 2) {
        [self closeOpenedTab];
        tab_open = 2;
        [menu_item2 runAction:[CCMoveBy actionWithDuration:0.1 position:ccp(0,-tab_animation_delta)]];
        [menu_item2_lbl runAction:[CCMoveBy actionWithDuration:0.1 position:ccp(0,-tab_animation_delta)]];
        cannonScrollMenu.position = ccp(10,cannonScrollMenu.contentSize.height+90);
        cannonScrollMenu.visible = YES;
        [cannonScrollMenu stopAllActions];
        [cannonScrollMenu runAction:[CCFadeIn actionWithDuration:0.6]];
        [cannonScrollMenu runAction:[CCMoveBy actionWithDuration:0.3 position:ccp(0,-cannonScrollMenu.contentSize.height)]];
        cannonScrollMenu.isTouchEnabled = YES;
    }
}

- (void) openExtras
{
    if (tab_open != 3) {
        [self closeOpenedTab];
        tab_open = 3;
        [menu_item3 runAction:[CCMoveBy actionWithDuration:0.1 position:ccp(0,-tab_animation_delta)]];
        [menu_item3_lbl runAction:[CCMoveBy actionWithDuration:0.1 position:ccp(0,-tab_animation_delta)]];
        extraScrollMenu.position = ccp(10,extraScrollMenu.contentSize.height+90);
        extraScrollMenu.visible = YES;
        [extraScrollMenu stopAllActions];
        [extraScrollMenu runAction:[CCFadeIn actionWithDuration:0.6]];
        [extraScrollMenu runAction:[CCMoveBy actionWithDuration:0.3 position:ccp(0,-extraScrollMenu.contentSize.height)]];
        extraScrollMenu.isTouchEnabled = YES;
    }
}

- (void) closeOpenedTab
{
    if (tab_open == 1) {
        [menu_item1 runAction:[CCMoveBy actionWithDuration:0.1 position:ccp(0,tab_animation_delta)]];
        [menu_item1_lbl runAction:[CCMoveBy actionWithDuration:0.1 position:ccp(0,tab_animation_delta)]];
        [gunScrollMenu stopAllActions];
        [gunScrollMenu runAction:[CCFadeOut actionWithDuration:0.3]];
        [gunScrollMenu runAction:[CCMoveBy actionWithDuration:0.3 position:ccp(0,-gunScrollMenu.contentSize.height)]];
        gunScrollMenu.isTouchEnabled = NO;
    } else if (tab_open == 2) {
        [menu_item2 runAction:[CCMoveBy actionWithDuration:0.1 position:ccp(0,tab_animation_delta)]];
        [menu_item2_lbl runAction:[CCMoveBy actionWithDuration:0.1 position:ccp(0,tab_animation_delta)]];
        [cannonScrollMenu stopAllActions];
        [cannonScrollMenu runAction:[CCFadeOut actionWithDuration:0.3]];
        [cannonScrollMenu runAction:[CCMoveBy actionWithDuration:0.3 position:ccp(0,-cannonScrollMenu.contentSize.height)]];
        cannonScrollMenu.isTouchEnabled = NO;
    } else if (tab_open == 3) {
        [menu_item3 runAction:[CCMoveBy actionWithDuration:0.1 position:ccp(0,tab_animation_delta)]];
        [menu_item3_lbl runAction:[CCMoveBy actionWithDuration:0.1 position:ccp(0,tab_animation_delta)]];
        [extraScrollMenu stopAllActions];
        [extraScrollMenu runAction:[CCFadeOut actionWithDuration:0.3]];
        [extraScrollMenu runAction:[CCMoveBy actionWithDuration:0.3 position:ccp(0,-extraScrollMenu.contentSize.height)]];
        extraScrollMenu.isTouchEnabled = NO;
    }
}

- (void) startGame
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameScene scene]]];
}

@end
