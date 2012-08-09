//
//  AppDelegate.h
//  TossThePanda
//
//  Created by Manpreet on 6/1/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//  sdfsfsf34234234324

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    NSUserDefaults * standardUserDefaults;
}

@property (nonatomic, retain) UIWindow *window;

- (void)setInt:(int)val forKey:(NSString*)key;
- (void)setString:(NSString*)val forKey:(NSString*)key;
- (void)setObject:(id)obj forKey:(NSString*)key;

@end
