//
//  ShopExtraPanel.h
//  TossThePanda
//
//  Created by Manpreet on 8/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "CCScrollMenuItem.h"
#import "RoundedRectNode.h"

@interface ShopExtraPanel : CCScrollMenuItem {
    
    NSUserDefaults * standardUserDefaults;
    
}

+ (id) newExtraPanel:(int)i;
- (id) init:(int)i;

@end
