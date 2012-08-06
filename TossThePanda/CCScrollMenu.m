//
//  CCScrollMenu.m
//  TossThePanda
//
//  Created by Manpreet on 8/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCScrollMenu.h"

@implementation CCScrollMenu

+ (id) newScrollMenu:(NSArray *)nodes padding:(int) padding
{
	return [[[self alloc] initScrollMenuWithNodes:nodes padding:padding] autorelease];
}

- (id) initScrollMenuWithNodes:(NSArray *)nodes padding:(int) padding
{
	if ((self = [super init]))
	{
        self.isTouchEnabled = YES;
        screenSize = [CCDirector sharedDirector].winSize;
        
        nodeItems = [[NSMutableArray alloc] initWithArray:nodes];
        
        CCScrollMenuItem *prevNode = nil;
        maxWidth = 0;
        maxHeight = 0;
        for (CCScrollMenuItem *n in nodes) {
            if (prevNode != nil) {
                n.position = ccp(prevNode.position.x + prevNode.contentSize.width + padding, 0);
            } else {
                n.position = ccp(0, 0);
            }
            
            n.anchorPoint = ccp(-0.5,-0.5);
            n.isRelativeAnchorPoint = YES;
            
            [self addChild:n];
            if (n.contentSize.height > maxHeight) maxHeight = n.contentSize.height;
            prevNode = n;
            maxWidth = maxWidth + prevNode.contentSize.width + padding;
        }
        
        self.contentSize = CGSizeMake(self.contentSize.width, maxHeight);
        higherLimitX = maxWidth;
    }
    return self;
}

- (void) onEnter
{
    lowerLimitX = self.position.x;
	[super onEnter];
}

- (void) onExit
{
	[super onExit];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    wasDragged = NO;
    CGRect rect = CGRectMake(self.position.x, self.position.y, maxWidth, self.contentSize.height);
    if (CGRectContainsPoint(rect, touchPoint)) {
        isDraggable = YES;
    } else {
        isDraggable = NO;
        return;
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    
    if (isDraggable == YES) {
        CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
        oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
        
        CGPoint touchPoint = [touch locationInView:[touch view]];
        touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
        
        CGPoint translation = ccpSub(touchPoint, oldTouchLocation);
        self.position = ccp(self.position.x + translation.x, self.position.y);
        
        wasDragged = YES;
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    if (wasDragged == NO) {
        for (CCScrollMenuItem *n in nodeItems) {
            CGRect rect = CGRectMake(n.position.x, n.position.y, n.contentSize.width, n.contentSize.height);
            if (CGRectContainsPoint(rect, touchLocation)) {
                if (n.invocation) [n.invocation invoke];
                break;
            }
        }
    } else {
        
        if (self.position.x > lowerLimitX) {
            CCMoveTo *changePage = [CCMoveTo actionWithDuration:0.3 position:ccp(lowerLimitX,self.position.y)];
            [self runAction:changePage];
        }
        
        if (self.position.x < -higherLimitX+screenSize.width) {
            CCMoveTo *changePage2 = [CCMoveTo actionWithDuration:0.3 position:ccp(-higherLimitX+screenSize.width,self.position.y)];
            [self runAction:changePage2];
        }
        
    }
}

- (void) dealloc
{
    [nodeItems release];
	[super dealloc];
}

@end
