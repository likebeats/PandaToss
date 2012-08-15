//
//  CCScrollMenuItem.m
//  TossThePanda
//
//  Created by Manpreet on 8/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCScrollMenuItem.h"

@implementation CCScrollMenuItem

- (void) setOnClick:(id)t selector:(SEL)s data:(int)i
{
    itemTarget = t;
    itemSelector = s;
    itemIndex = i;
}

- (void) callOnClickSelector
{
    if (itemTarget && itemSelector)
        [self runAction:[CCCallFuncND actionWithTarget:itemTarget selector:itemSelector data:(__bridge void *)([NSNumber numberWithInt:itemIndex])]];
}

- (void) setOpacity: (GLubyte) opacity
{
    for( CCNode *node in [self children] )
    {
        if( [node conformsToProtocol:@protocol( CCRGBAProtocol)] )
        {
            [(id<CCRGBAProtocol>) node setOpacity: opacity];
        }
    }
}

@end
