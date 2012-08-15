//
//  Menu.h
//  TossThePanda
//
//  Created by Manpreet on 7/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface Menu : CCLayer {
    
    CGSize screenSize;
    CGSize screenSizeInPixels;
    
}

+(CCScene *) scene;

- (void) initScene;

@end
