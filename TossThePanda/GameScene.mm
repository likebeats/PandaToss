//
//  GameScene.mm
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "GameScene.h"

enum {
	kBoxCollisionType = 1,
	kWallCollisionType = 2
};

@implementation GameScene

+ (CCScene*)scene
{
	CCScene *scene = [CCScene node];
	GameScene *layer = [GameScene node];
	[scene addChild: layer];
	return scene;
}

- (id)init
{
	if( (self=[super init])) {
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
        
		screenSize = [CCDirector sharedDirector].winSize;
		CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
		
		self.gravity = ccp(0.0f, -10.0f);
		
		// Define the simulation accuracy
		self.velocityIterations = 8;
		self.positionIterations = 1;
		
        [self initScene];
        
        [self debugDrawShapes:NO];
        [self debugDrawJoints:NO];
        [self debugDrawAABB:NO];
        [self debugDrawPair:NO];
        [self debugDrawCenterOfMass:NO];
	}
	return self;
}

- (void)initScene
{
    CCLabelTTF *powerLabel = [CCLabelTTF labelWithString:@"Power:" fontName:@"Chalkduster" fontSize: 14];
    [powerLabel setAnchorPoint:CGPointZero];
    [powerLabel setPosition:ccp(10,screenSize.height-20)];
    [self addChild:powerLabel];
    
    powerValue = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize: 14];
    [powerValue setAnchorPoint:CGPointZero];
    [powerValue setPosition:ccp(85,screenSize.height-20)];
    [self addChild:powerValue];
    
    CCLabelTTF *distanceLabel = [CCLabelTTF labelWithString:@"Distance:" fontName:@"Chalkduster" fontSize: 14];
    [distanceLabel setAnchorPoint:CGPointZero];
    [distanceLabel setPosition:ccp(10,screenSize.height-40)];
    [self addChild:distanceLabel];
    
    distanceValue = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize: 14];
    [distanceValue setAnchorPoint:CGPointZero];
    [distanceValue setPosition:ccp(85,screenSize.height-40)];
    [self addChild:distanceValue];
    
    CCLabelTTF *velocityLabel = [CCLabelTTF labelWithString:@"Velocity:" fontName:@"Chalkduster" fontSize: 14];
    [velocityLabel setAnchorPoint:CGPointZero];
    [velocityLabel setPosition:ccp(10,screenSize.height-60)];
    [self addChild:velocityLabel];
    
    velocityValue = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize: 14];
    [velocityValue setAnchorPoint:CGPointZero];
    [velocityValue setPosition:ccp(85,screenSize.height-60)];
    [self addChild:velocityValue];
    
    floorGroup = [CCNode node];
    bgGroup = [CCNode node];
    
    bgs = [[NSMutableArray alloc] initWithCapacity:2];
    for (int i = 0; i < 2; i++) {
        CCSprite *bg = [CCSprite spriteWithFile:@"bg.png"];
        bg.position = ccp(0,0);
        //[bgs addObject:bg];
        //[bgGroup addChild:bg];
    }
    
    themeBgs = [[NSMutableArray alloc] initWithCapacity:2];
    for (int i = 0; i < 2; i++) {
        CCSprite *themeBg = [CCSprite spriteWithFile:@"bamboo.png"];
        themeBg.position = ccp(themeBg.contentSize.width*i,themeBg.contentSize.height/2+75); // 75 is height of floor
        [themeBgs addObject:themeBg];
        [bgGroup addChild:themeBg];
    }
    
    floors = [[NSMutableArray alloc] initWithCapacity:3];
    for (int i = -1; i < 2; i++) {
        CCBodySprite *floor = [CCBodySprite spriteWithFile:@"bamboo_floor.png"];
        floor.world = self;
        floor.physicsType = kStatic;
        floor.collisionType = kBoxCollisionType;
        floor.collidesWithType = kBoxCollisionType | kWallCollisionType;
        floor.position = ccp(floor.contentSize.width*i, floor.contentSize.height/2);
        floor.density = 1.0f;
        floor.friction = 100.0f;
        floor.bounce = 0.5f;
        [floor addBoxWithName:@"floor"];
        [floors addObject:floor];
        [floorGroup addChild:floor];
    }
    
    player = [Player initWithFileName:@"panda3.png"];
	player.world = self;
    [floorGroup addChild:player];
    
    [self addChild:bgGroup];
    [self addChild:floorGroup];
    
    // enable the frame scheduler
    [self schedule:@selector(enterFrame:)];
}

- (void)enterFrame: (ccTime)dt
{
    NSString *distance = [NSString stringWithFormat:@"%.0f", player.position.x - [player getStartingPoint].x];
    [distanceValue setString:distance];
    
    int newX, newY;
    
    // move floorGroup
    newX = (-player.position.x + screenSize.width/2);
    if (player.position.y > 160) {
        newY = (-player.position.y + screenSize.height/2);
    } else {
        newY = floorGroup.position.y;
    }
    [floorGroup setPosition:ccp( newX, newY )];
    
    // move bgGroup
    newX = (-player.position.x + screenSize.width/2)/5;
    if (player.position.y > 160) {
        newY = (-player.position.y + screenSize.height/2);
    } else {
        newY = bgGroup.position.y;
    }
    [bgGroup setPosition:ccp( newX, newY )];
    
    [self repositionFloors];
    [self repositionThemeBgs];
    
    CCBodySprite *floor = [floors objectAtIndex:0];
    [player checkifPlayerStops:floor.position.y];
}

- (void)repositionFloors
{
    int next;
    for (int i = 0; i < 3; i++) {
        if (i == 0) next = 1;
        if (i == 1) next = 2;
        if (i == 2) next = 0;
        CCBodySprite *floor = [floors objectAtIndex:i];
        CCBodySprite *nextfloor = [floors objectAtIndex:next];
        
        if((player.position.x - floor.position.x) >= 480) {
            int newX = nextfloor.position.x+floor.contentSize.width;
            [floor setPosition:ccp(newX,floor.position.y)];
        }
    }
}

- (void)repositionThemeBgs
{
    int next;
    for (int i = 0; i < 2; i++) {
        if (i == 0) next = 1;
        if (i == 1) next = 0;
        CCBodySprite *themeBg = [themeBgs objectAtIndex:i];
        CCBodySprite *nextThemeBg = [themeBgs objectAtIndex:next];
        
        int playerx = player.position.x - floorGroup.position.x;
        NSLog(@"%i",playerx);
        if((playerx - themeBg.position.x) >= themeBg.contentSize.width) {
            int newX = nextThemeBg.position.x+themeBg.contentSize.width;
            [themeBg setPosition:ccp(newX,themeBg.position.y)];
        }
    }
}

- (void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSLog(@"touch began");
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch moved");
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch ended");
    //UITouch* touch = [touches anyObject];
    //CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    b2Vec2 force(100 / PTM_RATIO, 100 / PTM_RATIO);
    b2Vec2 b2Location(player.position.x / PTM_RATIO, player.position.y / PTM_RATIO);
    player.body->ApplyLinearImpulse(force, b2Location);
    [player rotateMe];
    player.isFlying = YES;
}

- (void) dealloc
{
    [floors release];
	[super dealloc];
}

- (void) onOverlapBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2
{
	// check if two boxes have started to overlap
	if (sprite1.collisionType == kBoxCollisionType && sprite2.collisionType == kBoxCollisionType) {
		
		//CCLOG(@"Two boxes have overlapped. Cool.");
	}
}

- (void) onSeparateBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2
{
	// check if two boxes are no longer overlapping
	if (sprite1.collisionType == kBoxCollisionType && sprite2.collisionType == kBoxCollisionType) {
		
		//CCLOG(@"Two boxes stopped overlapping. That's okay too.");
	}
}

- (void) onCollideBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2 withForce:(float)force withFrictionForce:(float)frictionForce
{
	// check if two boxes have collided in the last update
	if (sprite1.collisionType == kBoxCollisionType && sprite2.collisionType == kBoxCollisionType) {
		
		//CCLOG(@"Two boxes have collided, yay!");
	}
}

@end
