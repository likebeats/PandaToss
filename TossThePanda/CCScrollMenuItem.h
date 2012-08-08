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
    
    NSInvocation *invocation;
    
}

@property (nonatomic, retain) NSInvocation *invocation;

- (void) setOnClick:(id)target selector:(SEL)selector index:(int)index;
- (void) setOpacity: (GLubyte) opacity;

@end
