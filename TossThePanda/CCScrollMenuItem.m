//
//  CCScrollMenuItem.m
//  TossThePanda
//
//  Created by Manpreet on 8/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCScrollMenuItem.h"

@implementation CCScrollMenuItem

@synthesize invocation;

- (void) setOnClick:(id)target selector:(SEL)selector index:(int)index
{
    NSMethodSignature * sig = nil;
    
    if( target && selector ) {
        sig = [target methodSignatureForSelector:selector];
        
        self.invocation = nil;
        self.invocation = [NSInvocation invocationWithMethodSignature:sig];
        [self.invocation setTarget:target];
        [self.invocation setSelector:selector];
        [self.invocation setArgument:&index atIndex:2];
        
        [self.invocation retain];
    }
}

- (void) dealloc
{
	[super dealloc];
}

@end
