//
//  Menu.h
//  TossThePanda
//
//  Created by Manpreet on 7/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "CCScrollMenu.h"

@interface Shop : CCLayer {
    
    NSUserDefaults * standardUserDefaults;
    CGSize screenSize;
    CGSize screenSizeInPixels;
    
    NSArray *gun_titles;
    NSArray *gun_file_names;
    
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
    
    CCNode *gunDetailsPopup;
}

+(CCScene *) scene;

- (void) initScene;
- (void) closeOpenedTab;

@end
