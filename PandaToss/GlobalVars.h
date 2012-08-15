//
//  GlobalVars.h
//  PandaToss
//
//  Created by Manpreet on 8/14/12.
//
//

#import "cocos2d.h"
#import "GB2ShapeCache.h"

@interface GlobalVars : NSObject
{
    NSUserDefaults * standardUserDefaults;
}

@property (nonatomic) NSArray *themeNames;
@property (nonatomic) NSArray *gunCosts;
@property (nonatomic) NSArray *gunPowers;
@property (nonatomic) NSArray *gunAmmos;
@property (nonatomic) NSArray *gunTitles;
@property (nonatomic) NSArray *gunFileNames;
@property (nonatomic) NSArray *cannonTitles;
@property (nonatomic) NSArray *cannonFileNames;
@property (nonatomic) NSArray *cannonCosts;
@property (nonatomic) NSArray *cannonPowers;

+ (GlobalVars *)get;
- (id)init;

@end
