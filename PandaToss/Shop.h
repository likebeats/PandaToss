//
//  Menu.h
//  TossThePanda
//
//  Created by Manpreet on 7/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GlobalVars.h"
#import "cocos2d.h"
#import "AppDelegate.h"
#import "RoundedRectNode.h"
#import "CCScrollMenu.h"
#import "ShopGunPanel.h"
#import "ShopCannonPanel.h"
#import "ShopExtraPanel.h"

@interface Shop : CCLayer {
    
    NSUserDefaults * standardUserDefaults;
    CGSize screenSize;
    GlobalVars *globalVars;
    
    NSArray *gun_titles;
    NSArray *gun_file_names;
    NSArray *cannon_titles;
    
    NSMutableArray *gunsOwned;
    NSMutableArray *cannonsOwned;
    
    NSMutableArray *gun_panels;
    NSMutableArray *cannon_panels;
    NSMutableArray *extra_panels;
    
    CCMenu *tab_menu;
    CCMenuItemImage *menu_item1;
    CCMenuItemImage *menu_item2;
    CCMenuItemImage *menu_item3;
    
    CCLabelTTF *menu_item1_lbl;
    CCLabelTTF *menu_item2_lbl;
    CCLabelTTF *menu_item3_lbl;
    CCLabelTTF *bank_lbl;
    
    int tab_open;
    int tab_animation_delta;
    
    CCScrollMenu *gunScrollMenu;
    CCScrollMenu *cannonScrollMenu;
    CCScrollMenu *extraScrollMenu;
    
    CCNode *gunDetailsPopup;
    CCNode *cannonDetailsPopup;
    CCNode *extraDetailsPopup;
    
    int gunEquipped;
    int cannonEquipped;
}

+(CCScene *) scene;

- (void) initScene;
- (void) openGuns;
- (void) openCannons;
- (void) openExtras;
- (void) closeOpenedTab;

@end
