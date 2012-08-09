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
        screenSizeInPixels = [CCDirector sharedDirector].winSizeInPixels;
		
        [self initScene];
	}
	return self;
}

- (void)initScene
{
    tab_open = 0;
    tab_animation_delta = 10;
    
    CCSprite *bg = [CCSprite spriteWithFile:@"shop_bg.png"];
    bg.position = ccp(screenSize.width/2, screenSize.height/2);
    [self addChild:bg];
    
    menu_item1 = [CCMenuItemImage itemFromNormalImage:@"shop_menu_item.png" selectedImage:nil target:self selector:@selector(openGuns)];
    menu_item2 = [CCMenuItemImage itemFromNormalImage:@"shop_menu_item.png" selectedImage:nil target:self selector:@selector(openCannons)];
    menu_item3 = [CCMenuItemImage itemFromNormalImage:@"shop_menu_item.png" selectedImage:nil target:self selector:@selector(openExtras)];
    
    tab_menu = [CCMenu menuWithItems:menu_item1, menu_item2, menu_item3, nil];
    [tab_menu alignItemsHorizontallyWithPadding:10];
    [self addChild:tab_menu];
    
    CCSprite *top_board = [CCSprite spriteWithFile:@"shop_top_board.png"];
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
    
    CCSprite *money_counter = [CCSprite spriteWithFile:@"shop_money_counter.png"];
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
    CCMenuItemFont *retry_btn_item = [CCMenuItemFont itemFromString:@"< Toss the Panda" target:self selector:@selector(startGame)];
    retry_btn_item.color = ccc3(0,0,0);
    CCMenu *retry_btn = [CCMenu menuWithItems:retry_btn_item, nil];
    retry_btn.position = ccp(100,30);
    [self addChild:retry_btn];
    
    /* --------------------------  GUNS  ------------------------------------------  */
    gun_titles = [[NSArray alloc] initWithObjects:
                  @"Revolver",
                  @"Desert Eagle",
                  @"Shotgun",
                  @"Uzi",
                  @"Auto Shotgun",
                  @"AK-47",
                  @"Sniper",
                  @"RPG",
                  @"Golden Gun", nil];
    gun_file_names = [[NSArray alloc] initWithObjects:
                      @"revolver.png",
                      @"desert_eagle.png",
                      @"shotgun.png",
                      @"uzi.png",
                      @"automatic_shotgun.png",
                      @"ak_47.png",
                      @"sniper.png",
                      @"rpg.png",
                      @"golden_hand_gun.png", nil];
    
    gunEquipped = [standardUserDefaults integerForKey:@"gunId"];
    gunsOwned = [standardUserDefaults objectForKey:@"gunsOwned"];
    gun_panels = [[NSMutableArray alloc] initWithCapacity:[gun_titles count]];
    
    for (int i=0; i<[gun_titles count]; i++) {
        NSString *gun_title = [gun_titles objectAtIndex:i];
        NSString *gun_file_name = [gun_file_names objectAtIndex:i];
        
        ShopGunPanel *panelNode = [ShopGunPanel newGunPanel:i];
        panelNode.contentSize = CGSizeMake(142,88);
        panelNode.gunName = gun_title;
        panelNode.gunFileName = gun_file_name;
        
        [panelNode setOnClick:self selector:@selector(openGunDetails:) index:i];
        
        [gun_panels addObject:panelNode];
    }
    
    gunScrollMenu = [CCScrollMenu newScrollMenu:gun_panels padding:20];
    gunScrollMenu.position = ccp(10,90);
    [gunScrollMenu setOpacity:0];
    gunScrollMenu.isTouchEnabled = NO;
    [self addChild:gunScrollMenu];
    /* --------------------------  END GUNS  --------------------------------------  */
    
    /* --------------------------  CANNONS   --------------------------------------  */
    NSArray *cannon_titles = [NSArray arrayWithObjects:@"Wood", @"Metal", @"Gold", @"Tank", nil];
    
    cannonEquipped = [standardUserDefaults integerForKey:@"cannonId"];
    cannonsOwned = [standardUserDefaults objectForKey:@"cannonsOwned"];
    cannon_panels = [[NSMutableArray alloc] initWithCapacity:[cannon_titles count]];
    
    for (int i=0; i<[cannon_titles count]; i++) {
        CCScrollMenuItem *panelNode = [CCScrollMenuItem node];
        panelNode.contentSize = CGSizeMake(142,88);
        
        RoundedRectNode *panel = [RoundedRectNode newRectWithSize:panelNode.contentSize];
        panel.borderWidth = 2.5;
        panel.position = ccp(-panelNode.contentSize.width/2,panelNode.contentSize.height/2);
        panel.color = ccc4(235, 241, 199, 255*0.7);
        panel.borderColor = ccc4(167, 172, 135, 255*0.7);
        panel.radius = 5;
        panel.cornerSegments = 5;
        
        CCLabelTTF *cannon_title_lbl = [CCLabelTTF labelWithString:[cannon_titles objectAtIndex:i] fontName:@"Papyrus" fontSize: 24];
        cannon_title_lbl.color = ccc3(0, 0, 0);
        cannon_title_lbl.position = ccp(0,0);
        
        [panelNode addChild:panel];
        [panelNode addChild:cannon_title_lbl];
        [cannon_panels addObject:panelNode];
    }
    cannonScrollMenu = [CCScrollMenu newScrollMenu:cannon_panels padding:20];
    cannonScrollMenu.position = ccp(10,90);
    [cannonScrollMenu setOpacity:0];
    cannonScrollMenu.isTouchEnabled = NO;
    [self addChild:cannonScrollMenu];
    /* --------------------------  END CANNONS   ----------------------------------  */
    
    /* --------------------------  EXTRAS   ---------------------------------------  */
    extra_panels = [[NSMutableArray alloc] initWithCapacity:10];
    
    for (int i=0; i<10; i++) {
        CCScrollMenuItem *panelNode = [CCScrollMenuItem node];
        panelNode.contentSize = CGSizeMake(142,88);
        
        RoundedRectNode *panel = [RoundedRectNode newRectWithSize:panelNode.contentSize];
        panel.borderWidth = 2.5;
        panel.position = ccp(-panelNode.contentSize.width/2,panelNode.contentSize.height/2);
        panel.color = ccc4(235, 241, 199, 255*0.7);
        panel.borderColor = ccc4(167, 172, 135, 255*0.7);
        panel.radius = 5;
        panel.cornerSegments = 5;
        
        [panelNode addChild:panel];
        [extra_panels addObject:panelNode];
    }
    extraScrollMenu = [CCScrollMenu newScrollMenu:extra_panels padding:20];
    extraScrollMenu.position = ccp(10,90);
    [extraScrollMenu setOpacity:0];
    extraScrollMenu.isTouchEnabled = NO;
    [self addChild:extraScrollMenu];
    /* --------------------------  END EXTRAS   ----------------------------------  */
    
    [self openGuns];
}

- (void) disableTouchesForPopup
{
    tab_menu.isTouchEnabled = NO;
    gunScrollMenu.isTouchEnabled = NO;
}

- (void) enableTouchesForPopup
{
    tab_menu.isTouchEnabled = YES;
    gunScrollMenu.isTouchEnabled = YES;
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

- (void) openGunDetails:(int)index
{
    [self disableTouchesForPopup];
    
    gunDetailsPopup = [CCNode node];
    gunDetailsPopup.contentSize = CGSizeMake(350, 175);
    gunDetailsPopup.position = ccp(screenSize.width/2, screenSize.height/2-20);
    gunDetailsPopup.scale = 0;
    [self addChild:gunDetailsPopup z:2];
    
    RoundedRectNode *popup_bg = [RoundedRectNode newRectWithSize:gunDetailsPopup.contentSize];
    popup_bg.borderWidth = 2.5;
    popup_bg.position = ccp(-gunDetailsPopup.contentSize.width/2,gunDetailsPopup.contentSize.height/2+10);
    popup_bg.color = ccc4(235, 241, 199, 255);
    popup_bg.borderColor = ccc4(167, 172, 135, 255);
    popup_bg.radius = 5;
    popup_bg.cornerSegments = 5;
    [gunDetailsPopup addChild:popup_bg];
    
    [CCMenuItemFont setFontSize:24];
    CCMenuItemFont *close_btn_item = [CCMenuItemFont itemFromString:@"X" target:self selector:@selector(closeGunDetailsPopup)];
    close_btn_item.color = ccc3(93, 154, 21);
    CCMenu *close_btn = [CCMenu menuWithItems:close_btn_item, nil];
    close_btn.position = ccp(-150,75);
    [gunDetailsPopup addChild:close_btn];
    
    CCLabelTTF *gun_title = [CCLabelTTF labelWithString:[gun_titles objectAtIndex:index] fontName:@"Papyrus" fontSize: 28];
    gun_title.position = ccp(0,65);
    gun_title.color = ccc3(93, 154, 21);
    [gunDetailsPopup addChild:gun_title];
    
    RoundedRectNode *gun_bg = [RoundedRectNode newRectWithSize:CGSizeMake(160, 100)];
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
    [gunDetailsPopup addChild:gun_info_bg];
    
    CCSprite *gun_sprite = [CCSprite spriteWithFile:[gun_file_names objectAtIndex:index]];
    gun_sprite.position = ccp(-80,-10);
    gun_sprite.scale = 1.5;
    [gunDetailsPopup addChild:gun_sprite];
    
    CCLabelTTF *gun_cost = [CCLabelTTF labelWithString:@"Cost: $0" fontName:@"Chalkduster" fontSize: 14];
    CCLabelTTF *gun_power = [CCLabelTTF labelWithString:@"Power: 0" fontName:@"Chalkduster" fontSize: 14];
    CCLabelTTF *gun_ammo = [CCLabelTTF labelWithString:@"Ammo: 0" fontName:@"Chalkduster" fontSize: 14];
    gun_cost.position = ccp(60,28);
    gun_power.position = ccp(gun_cost.position.x,gun_cost.position.y-18);
    gun_ammo.position = ccp(gun_cost.position.x,gun_power.position.y-18);
    gun_cost.color = ccDARKGOLDENROD;
    gun_power.color = ccDARKGOLDENROD;
    gun_ammo.color = ccDARKGOLDENROD;
    [gunDetailsPopup addChild:gun_cost];
    [gunDetailsPopup addChild:gun_power];
    [gunDetailsPopup addChild:gun_ammo];
    
    [CCMenuItemFont setFontSize:24];
    CCMenuItemFont *buy_btn_item = [CCMenuItemFont itemFromString:@"Buy" block:^(id sender) {
        [self buyGun:index];
    }];
    CCMenuItemFont *equip_btn_item = [CCMenuItemFont itemFromString:@"Equip" block:^(id sender) {
        [self equipGun:index];
    }];
    buy_btn_item.color = ccc3(0,0,0);
    equip_btn_item.color = ccc3(0,0,0);
    CCMenu *gun_options_menu = [CCMenu menuWithItems:buy_btn_item, equip_btn_item, nil];
    gun_options_menu.position = ccp(80,-45);
    [gun_options_menu alignItemsHorizontallyWithPadding:20];
    [gunDetailsPopup addChild:gun_options_menu];
    
    switch (index) {
        case 0: // Revolver
            
            break;
        case 1: // Desert Eagle
            
            break;
        case 2: // Shotgun
            
            break;
        case 3: // Uzi
            
            break;
        case 4: // Automatic Shotgun
            
            break;
        case 5: // AK 47
            
            break;
        case 6: // Sniper
            
            break;
        case 7: // RPG
            
            break;
        case 8: // Golden Gun
            
            break;
        default:
            break;
    }
    
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

- (void) openGuns
{
    if (tab_open != 1) {
        [self closeOpenedTab];
        tab_open = 1;
        [menu_item1 runAction:[CCMoveBy actionWithDuration:0.1 position:ccp(0,-tab_animation_delta)]];
        [menu_item1_lbl runAction:[CCMoveBy actionWithDuration:0.1 position:ccp(0,-tab_animation_delta)]];
        gunScrollMenu.position = ccp(10,gunScrollMenu.contentSize.height+90);
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

- (void) dealloc
{
    [gun_titles release];
    [gun_file_names release];
    [gun_panels release];
    [cannon_panels release];
    [extra_panels release];
	[super dealloc];
}

@end
