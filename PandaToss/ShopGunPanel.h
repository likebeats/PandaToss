//
//  ShopGunPanel.h
//  TossThePanda
//
//  Created by Manpreet on 8/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "CCScrollMenuItem.h"

@interface ShopGunPanel : CCScrollMenuItem {
    
    NSUserDefaults * standardUserDefaults;
    
    NSString *gunName;
    NSString *gunFileName;
    
    CCLabelTTF *equipped_lbl;
    
    int gunIndex;
}

@property (nonatomic, retain) NSString *gunName;
@property (nonatomic, retain) NSString *gunFileName;
@property (nonatomic, retain) CCLabelTTF *equipped_lbl;

+ (id) newGunPanel:(int)i;
- (id) init:(int)i;

@end
