//
//  GlobalVars.mm
//  PandaToss
//
//  Created by Manpreet on 8/14/12.
//
//

#import "GlobalVars.h"

@implementation GlobalVars

@synthesize themeNames,
cannonTitles,
cannonFileNames,
cannonCosts,
cannonPowers,
gunAmmos,
gunCosts,
gunFileNames,
gunPowers,
gunTitles;

+ (GlobalVars *)get
{
    static GlobalVars *gInstance = NULL;
    @synchronized(self)
    {
        if (gInstance == NULL)
            gInstance = [[self alloc] init];
    }
    
    return(gInstance);
}

- (id)init
{
	if( (self=[super init])) {
        
        NSLog(@"initing Global Vars");
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"pandatoss.plist"];
        
        [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"shapes.plist"];
        
        standardUserDefaults = [NSUserDefaults standardUserDefaults];
        
        themeNames = [[NSArray alloc] initWithObjects:
                           @"bamboo",
                           @"forest",
                           @"desert", nil];
        
        gunCosts = [[NSArray alloc] initWithObjects:
                    [NSNumber numberWithInteger:1],
                    [NSNumber numberWithInteger:0],
                    [NSNumber numberWithInteger:0],
                    [NSNumber numberWithInteger:0],
                    [NSNumber numberWithInteger:0],
                    [NSNumber numberWithInteger:0],
                    [NSNumber numberWithInteger:0],
                    [NSNumber numberWithInteger:0],
                    [NSNumber numberWithInteger:0], nil];
        
        gunPowers = [[NSArray alloc] initWithObjects:
                     [NSNumber numberWithInteger:1],
                     [NSNumber numberWithInteger:0],
                     [NSNumber numberWithInteger:0],
                     [NSNumber numberWithInteger:0],
                     [NSNumber numberWithInteger:0],
                     [NSNumber numberWithInteger:0],
                     [NSNumber numberWithInteger:0],
                     [NSNumber numberWithInteger:0],
                     [NSNumber numberWithInteger:0], nil];
        
        gunAmmos = [[NSArray alloc] initWithObjects:
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:3],
                    [NSNumber numberWithInteger:3], nil];
        
        gunTitles = [[NSArray alloc] initWithObjects:
                      @"Revolver",
                      @"Desert Eagle",
                      @"Shotgun",
                      @"Uzi",
                      @"Auto Shotgun",
                      @"AK-47",
                      @"Sniper",
                      @"RPG",
                      @"Golden Gun", nil];
        
        gunFileNames = [[NSArray alloc] initWithObjects:
                          @"revolver.png",
                          @"desert_eagle.png",
                          @"shotgun.png",
                          @"uzi.png",
                          @"automatic_shotgun.png",
                          @"ak_47.png",
                          @"sniper.png",
                          @"rpg.png",
                          @"golden_hand_gun.png", nil];
        
        cannonTitles = [[NSArray alloc] initWithObjects:@"Wood", @"Metal", @"Gold", @"Tank", nil];
        cannonFileNames = [[NSArray alloc] initWithObjects:
                           @"wood",
                           @"metal",
                           @"gold",
                           @"tank", nil];
        
        cannonCosts = [[NSArray alloc] initWithObjects:
                       [NSNumber numberWithInteger:1],
                       [NSNumber numberWithInteger:0],
                       [NSNumber numberWithInteger:0],
                       [NSNumber numberWithInteger:0], nil];
        
        cannonPowers = [[NSArray alloc] initWithObjects:
                        [NSNumber numberWithInteger:1],
                        [NSNumber numberWithInteger:0],
                        [NSNumber numberWithInteger:0],
                        [NSNumber numberWithInteger:0], nil];
        
        NSMutableArray *gunsOwned = [[NSMutableArray alloc] initWithObjects:
                                     [NSNumber numberWithInteger:1],
                                     [NSNumber numberWithInteger:0],
                                     [NSNumber numberWithInteger:0],
                                     [NSNumber numberWithInteger:0],
                                     [NSNumber numberWithInteger:0],
                                     [NSNumber numberWithInteger:0],
                                     [NSNumber numberWithInteger:0],
                                     [NSNumber numberWithInteger:0],
                                     [NSNumber numberWithInteger:0], nil];
        
        NSMutableArray *cannonsOwned = [[NSMutableArray alloc] initWithObjects:
                                        [NSNumber numberWithInteger:1],
                                        [NSNumber numberWithInteger:0],
                                        [NSNumber numberWithInteger:0],
                                        [NSNumber numberWithInteger:0], nil];
        
        [self setObject:gunsOwned forKey:@"gunsOwned"];
        [self setObject:cannonsOwned forKey:@"cannonsOwned"];
        
        [self setInt:100 forKey:@"bank"];
        [self setInt:0 forKey:@"themeId"];
        [self setInt:0 forKey:@"cannonId"];
        [self setInt:0 forKey:@"gunId"];
        
    }
    return self;
}

- (void)setInt:(int)val forKey:(NSString*)key
{
    if (![standardUserDefaults integerForKey:key]) {
        [standardUserDefaults setInteger:val forKey:key];
    }
}

- (void)setString:(NSString*)val forKey:(NSString*)key
{
    if (![standardUserDefaults objectForKey:key]) {
        [standardUserDefaults setObject:val forKey:key];
    }
}

- (void)setObject:(id)obj forKey:(NSString*)key
{
    if (![standardUserDefaults objectForKey:key]) {
        [standardUserDefaults setObject:obj forKey:key];
    }
}

@end
