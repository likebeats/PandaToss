//
//  ScoreScene.h
//  TossThePanda
//
//  Created by Manpreet on 7/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

#import "GameScene.h"

@interface ScoreScene : CCLayerColor {
    
    CGSize screenSize;
    CGSize screenSizeInPixels;
    
}

- (void) initScene;
- (void) onTransitionFinish;

@end
