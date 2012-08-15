//
//  CCScrollMenuItem.h
//  TossThePanda
//
//  Created by Manpreet on 8/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCScrollMenuItem : CCNode {
    
    id itemTarget;
    SEL itemSelector;
    int itemIndex;
    
}

- (void) setOnClick:(id)t selector:(SEL)s data:(int)i;
- (void) callOnClickSelector;
- (void) setOpacity: (GLubyte) opacity;

@end
