//
//  CCScrollMenu.h
//  TossThePanda
//
//  Created by Manpreet on 8/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCScrollMenuItem.h"

@interface CCScrollMenu : CCLayer
{
    CGSize screenSize;
    
    NSMutableArray *nodeItems;
    
    BOOL isDraggable;
    BOOL wasDragged;
    
    int maxWidth;
    int maxHeight;
    int lowerLimitX;
    int higherLimitX;
}

+ (id) newScrollMenu:(NSArray *)nodes padding:(int) padding;
- (id) initScrollMenuWithNodes:(NSArray *)nodes padding:(int) padding;

@end
