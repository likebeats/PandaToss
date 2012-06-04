//
//  AppDelegate.h
//  TossThePanda
//
//  Created by Manpreet on 6/1/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//  sdfggssgfdsfsdf

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
