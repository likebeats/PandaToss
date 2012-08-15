//
//  ShopCannonPanel.h
//  TossThePanda
//
//  Created by Manpreet on 8/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "CCScrollMenuItem.h"
#import "RoundedRectNode.h"

@interface ShopCannonPanel : CCScrollMenuItem {
    
    NSUserDefaults * standardUserDefaults;
    
    NSString *cannonName;
    NSString *cannonFileName;
    
    CCLabelTTF *equipped_lbl;
    
    int cannonIndex;
}

@property (nonatomic, retain) NSString *cannonName;
@property (nonatomic, retain) NSString *cannonFileName;
@property (nonatomic, retain) CCLabelTTF *equipped_lbl;

+ (id) newCannonPanel:(int)i;
- (id) init:(int)i;

@end
