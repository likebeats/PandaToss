//
//  ShopGunPanel.h
//  TossThePanda
//
//  Created by Manpreet on 8/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCScrollMenuItem.h"
#import "RoundedRectNode.h"

@interface ShopGunPanel : CCScrollMenuItem {
    
    NSUserDefaults * standardUserDefaults;
    
    NSString *gunName;
    NSString *gunFileName;
    
    CCLabelTTF *equipped_lbl;
    
    int index;
}

@property (nonatomic, assign) NSString *gunName;
@property (nonatomic, assign) NSString *gunFileName;
@property (nonatomic, assign) CCLabelTTF *equipped_lbl;

+ (id) newGunPanel:(int)i;

@end
