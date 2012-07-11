//
//  GameScene.mm
//  TossThePanda
//
//  Created by Manpreet on 6/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Types.h"
#import "GameScene.h"

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
		
        standardUserDefaults = [NSUserDefaults standardUserDefaults];
        
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = NO;
        
        screenSize = [CCDirector sharedDirector].winSize;
        screenSizeInPixels = [CCDirector sharedDirector].winSizeInPixels;
		
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
    NSString *theme_name;
    int themeId = [standardUserDefaults integerForKey:@"themeId"];
    if (themeId == 1) {
        theme_name = @"bamboo";
    } else if (themeId == 2) {
        theme_name = @"forest";
    } else if (themeId == 3) {
        theme_name = @"desert";
    }
    
    NSString *cannon_name;
    int cannonId = [standardUserDefaults integerForKey:@"cannonId"];
    if (cannonId == 1) {
        cannon_name = @"wood";
    } else if (cannonId == 2) {
        cannon_name = @"metal";
    } else if (cannonId == 3) {
        cannon_name = @"gold";
    } else if (cannonId == 4) {
        cannon_name = @"tank";
    }
    
    xnew = 0;
    
    goodBall = 0;
    goodTime = 20;
    newGoodTime = 30;
    
    floorGroup = [CCNode node];
    bgGroup = [CCNode node];
    
    goodies = [[CCArray alloc] init];
    baddies = [[CCArray alloc] init];
    
    gradientsGroups = [[NSMutableArray alloc] initWithCapacity:2];
    for (int j = 0; j < 2; j++) {
        ccColor4B startColor;
        ccColor4B fadeTo;
        int lowerGradientY = 0;
        int lowerGradientHeight = 0;
        CCNode *gradientGroup = [CCNode node];
        for (int i = 0; i < 3; i++) {
            if (i == 0) {
                startColor = ccc4(255,255,153,255);
                fadeTo = ccc4(253,62,62,255);
            } else if (i == 1) {
                startColor = ccc4(253,62,62,255);
                fadeTo = ccc4(50,19,121,255);
            } else if (i == 2) {
                startColor = ccc4(50,19,121,255);
                fadeTo = ccc4(0,0,0,255);
            }
            CCLayerGradient *bgGradient = [CCLayerGradient layerWithColor:startColor fadingTo:fadeTo alongVector:ccp(0,1)];
            [bgGradient setContentSize:CGSizeMake(700, 3000+(1000*i))];
            [bgGradient setPosition:ccp(0,lowerGradientY+lowerGradientHeight)];
            
            lowerGradientY = bgGradient.position.y;
            lowerGradientHeight = bgGradient.contentSize.height;
            
            [gradientGroup addChild:bgGradient];
        }
        [gradientGroup setPosition:ccp(0+(700*j),0)];
        [gradientsGroups addObject:gradientGroup];
        [bgGroup addChild:gradientGroup z:-1];
    }
    
    themeBgs = [[NSMutableArray alloc] initWithCapacity:2];
    int bgoffset = 0;
    for (int i = 0; i < 2; i++) {
        CCSprite *themeBg = [CCSprite spriteWithFile:[theme_name stringByAppendingString:@".png"]];
        themeBg.position = ccp(themeBg.contentSize.width*i-bgoffset,themeBg.contentSize.height/2+75-1); // 75 is height of floor
        [themeBgs addObject:themeBg];
        [bgGroup addChild:themeBg];
        bgoffset = 1;
    }
    
    
    CCArray *floorVertices = nil;
    floors = [[NSMutableArray alloc] initWithCapacity:3];
    int offset = 0;
    for (int i = 0; i < 3; i++) {
        CCBodySprite *floor = [CCBodySprite spriteWithFile:[theme_name stringByAppendingString:@"_floor.png"]];
        floor.world = self;
        floor.physicsType = kStatic;
        floor.collisionType = kFloorCollisionType;
        floor.collidesWithType = kPlayerCollisionType;
        floor.position = ccp(floor.contentSize.width*i-offset, floor.contentSize.height/2);
        floor.density = 1.0f;
        floor.friction = 1.0f;
        floor.bounce = 0.5f;
        
        if (!floorVertices) {
            float halfWidth = floor.contentSize.width/2;
            float halfHeight = floor.contentSize.height/2;
            floorVertices = [CCArray arrayWithCapacity:8];
            [floorVertices addObject:[NSValue valueWithCGPoint:ccp(-halfWidth, -halfHeight)]];
            [floorVertices addObject:[NSValue valueWithCGPoint:ccp(halfWidth, -halfHeight)]];
            [floorVertices addObject:[NSValue valueWithCGPoint:ccp(halfWidth, halfHeight-30)]];
            [floorVertices addObject:[NSValue valueWithCGPoint:ccp(-halfWidth, halfHeight-30)]];
        }
        
        [floor addPolygonWithName:@"floor" withVertices:floorVertices];
        [floors addObject:floor];
        [floorGroup addChild:floor];
        offset = 2;
    }
    
    player = [Player newPlayer];
	player.world = self;
    [floorGroup addChild:player];
    
    cannon = [Cannon cannonWithName:cannon_name StartingPosition:player.startingPoint];
    cannon.position = player.position;
    [floorGroup addChild:cannon];
    
    fallLine = cannon.position.y-20;
    
    [self addChild:bgGroup];
    [self addChild:floorGroup];
    
    [self createLabels];
    
    // enable the frame scheduler
    [self schedule:@selector(enterFrame:)];
}

- (void)createLabels
{
    CCLabelTTF *powerLabel = [CCLabelTTF labelWithString:@"Power:" fontName:@"Chalkduster" fontSize: 14];
    [powerLabel setAnchorPoint:CGPointZero];
    [powerLabel setPosition:ccp(10,screenSize.height-20)];
    [powerLabel setColor:ccc3(255, 0, 255)];
    [self addChild:powerLabel];
    
    powerValue = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize: 14];
    [powerValue setAnchorPoint:CGPointZero];
    [powerValue setPosition:ccp(85,screenSize.height-20)];
    [powerValue setColor:ccc3(255, 0, 255)];
    [self addChild:powerValue];
    
    CCLabelTTF *distanceLabel = [CCLabelTTF labelWithString:@"Distance:" fontName:@"Chalkduster" fontSize: 14];
    [distanceLabel setAnchorPoint:CGPointZero];
    [distanceLabel setPosition:ccp(10,screenSize.height-40)];
    [distanceLabel setColor:ccc3(255, 0, 255)];
    [self addChild:distanceLabel];
    
    distanceValue = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize: 14];
    [distanceValue setAnchorPoint:CGPointZero];
    [distanceValue setPosition:ccp(85,screenSize.height-40)];
    [distanceValue setColor:ccc3(255, 0, 255)];
    [self addChild:distanceValue];
    
    CCLabelTTF *heightLabel = [CCLabelTTF labelWithString:@"Height:" fontName:@"Chalkduster" fontSize: 14];
    [heightLabel setAnchorPoint:CGPointZero];
    [heightLabel setPosition:ccp(10,screenSize.height-60)];
    [heightLabel setColor:ccc3(255, 0, 255)];
    [self addChild:heightLabel];
    
    heightValue = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize: 14];
    [heightValue setAnchorPoint:CGPointZero];
    [heightValue setPosition:ccp(85,screenSize.height-60)];
    [heightValue setColor:ccc3(255, 0, 255)];
    [self addChild:heightValue];
    
    CCLabelTTF *velocityLabel = [CCLabelTTF labelWithString:@"Velocity:" fontName:@"Chalkduster" fontSize: 14];
    [velocityLabel setAnchorPoint:CGPointZero];
    [velocityLabel setPosition:ccp(10,screenSize.height-80)];
    [velocityLabel setColor:ccc3(255, 0, 255)];
    [self addChild:velocityLabel];
    
    velocityValue = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize: 14];
    [velocityValue setAnchorPoint:CGPointZero];
    [velocityValue setPosition:ccp(85,screenSize.height-80)];
    [velocityValue setColor:ccc3(255, 0, 255)];
    [self addChild:velocityValue];
}

- (void)enterFrame: (ccTime)dt
{
    NSString *distance = [NSString stringWithFormat:@"%.0f", player.position.x - player.startingPoint.x];
    [distanceValue setString:distance];
    
    NSString *velocity = [NSString stringWithFormat:@"%.0f, %.0f", player.velocity.x, player.velocity.y];
    [velocityValue setString:velocity];
    
    NSString *height = [NSString stringWithFormat:@"%.0f", player.position.y];
    [heightValue setString:height];
    
    if (!cannon.isRotating) [self moveCamera];
    [self repositionFloors];
    [self repositionGradientBgs];
    [self repositionThemeBgs];
    
    [self spawnGoodies];
    [self spawnBaddies];
    [self removeOffScreenObjects];
    
    // Check when player stops/slows player down at low velocity
    BOOL checkPlayerStop = [player checkIfPlayerStops:[[floors objectAtIndex:0] position].y];
    [player controlPlayerFire];
    [player controlRotating:dt];
    
    if (checkPlayerStop == YES && roundDone == NO) {
        roundDone = YES;
        [self openScoreScreen];
    }
}

- (void)moveCamera
{
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
}

- (void)repositionFloors
{
    int next;
    int offset = 2;
    for (int i = 0; i < 3; i++) {
        if (i == 0) next = 1;
        else if (i == 1) next = 2;
        else if (i == 2) next = 0;
        CCBodySprite *floor = [floors objectAtIndex:i];
        CCBodySprite *nextfloor = [floors objectAtIndex:next];
        
        if ((player.position.x - floor.position.x) >= 480) {
            int newX = nextfloor.position.x+floor.contentSize.width;
            [floor setPosition:ccp(newX-offset,floor.position.y)];
        }
    }
}

- (void)repositionGradientBgs
{
    int next;
    for (int i = 0; i < 2; i++) {
        if (i == 0) next = 1;
        else if (i == 1) next = 0;
        CCNode *group = [gradientsGroups objectAtIndex:i];
        CCNode *nextGroup = [gradientsGroups objectAtIndex:next];
        
        int groupLocalx = group.nodeToWorldTransform.tx;
        int playerLocalx = player.nodeToWorldTransform.tx;
        
        if((playerLocalx - groupLocalx) >= (screenSizeInPixels.width*2)+100) {
            int newX = nextGroup.position.x+700;
            [group setPosition:ccp(newX,group.position.y)];
        }
    }
}

- (void)repositionThemeBgs
{
    int next;
    int bgoffset = 1;
    for (int i = 0; i < 2; i++) {
        if (i == 0) next = 1;
        else if (i == 1) next = 0;
        CCBodySprite *themeBg = [themeBgs objectAtIndex:i];
        CCBodySprite *nextThemeBg = [themeBgs objectAtIndex:next];
        
        int themeBgLocalx = themeBg.nodeToWorldTransform.tx;
        int playerLocalx = player.nodeToWorldTransform.tx;
        
        if((playerLocalx - themeBgLocalx) >= (screenSizeInPixels.width*2)+100) {
            int newX = nextThemeBg.position.x+themeBg.contentSize.width;
            [themeBg setPosition:ccp(newX-bgoffset,themeBg.position.y)];
        }
    }
}

- (void)spawnGoodies
{
    if (goodTime < 1 && player.position.x > goodBall + 150)
    {
        int spawnedAll = 5;
        xnew = player.position.x + 800;
        if ((arc4random() % 30) == 0 && spawnedAll > 0)
        {
            NSLog(@"spawning campfire");
            xnew = xnew + (150 + (arc4random() % 300));
            
            Animation *campFire = [Animation newAnimationWithBody:@"campfire.png" 
                                                         Position:ccp(xnew, fallLine) 
                                                        DelayTime:0.2 
                                                      TotalFrames:2 
                                                        SheetRows:1 
                                                     SheetColumns:2 
                                                       FrameWidth:80 
                                                      FrameHeight:120 
                                                    RepeatForever:YES 
                                                            World:self 
                                                      PhysicsType:kStatic 
                                                          BoxName:@"campfire" 
                                                          BoxSize:CGSizeMake(70, 50) 
                                                    CollisionType:kFireCollisionType 
                                                 CollidesWithType:kPlayerCollisionType ];
            [floorGroup addChild:campFire z:1];
            [goodies addObject:campFire];
            
            spawnedAll--;
        }
        goodBall = player.position.x;
        goodTime = newGoodTime;
    }
    goodTime--;
}

- (void)spawnBaddies
{
    
}

- (void)removeOffScreenObjects
{
    id object;
    CCARRAY_FOREACH(goodies, object) {
        BOOL test = [object isKindOfClass:[Animation class]];
        if (test) {
            Animation *animation = object;
            if ((player.position.x - animation.sprite.position.x) > 700) {
                [animation removeAnimation];
                [goodies removeObject:animation];
            }
        } else {
            CCBodySprite *sprite = object;
            if ((player.position.x - sprite.position.x) > 700) {
                [sprite removeFromParentAndCleanup:YES];
                [goodies removeObject:sprite];
            }
        }
    }
    
    CCARRAY_FOREACH(baddies, object) {
        BOOL test = [object isKindOfClass:[Animation class]];
        if (test) {
            Animation *animation = object;
            if ((player.position.x - animation.sprite.position.x) > 700) {
                [animation removeAnimation];
                [goodies removeObject:animation];
            }
        } else {
            CCBodySprite *sprite = object;
            if ((player.position.x - sprite.position.x) > 700) {
                [sprite removeFromParentAndCleanup:YES];
                [goodies removeObject:sprite];
            }
        }
    }
}

- (void)rotateCannonMouth: (CGPoint)touch
{
    float cannonLocalx = cannon.nodeToWorldTransform.tx;
    float cannonLocaly = cannon.nodeToWorldTransform.ty;
    
    if ([[CCDirector sharedDirector] enableRetinaDisplay:YES]) {
        cannonLocalx = cannonLocalx/2;
        cannonLocaly = cannonLocaly/2;
    }
    
    float xx = touch.x - cannonLocalx;
    float yy = touch.y - cannonLocaly;
    float degree = CC_RADIANS_TO_DEGREES(atan2(yy,xx));
    [cannon rotateMouth:-degree];
    int playerNewX = cannonLocalx + cos(CC_DEGREES_TO_RADIANS(-cannon.mouth.rotation))*cannon.playerOffset.x;
    int playerNewY = cannonLocaly + sin(CC_DEGREES_TO_RADIANS(-cannon.mouth.rotation))*cannon.playerOffset.y;
    player.position = ccp(playerNewX,playerNewY);
}

- (void)reset
{
    roundDone = NO;
    self.isTouchEnabled = YES;
    [self removeChild:scoreScreen cleanup:YES];
    [self removeChild:menuScreen cleanup:YES];
    player.physicsType = kStatic;
    player.visible = NO;
    
    for (int j = 0; j < 2; j++) {
        CCNode *gradientGroup = [gradientsGroups objectAtIndex:j];
        [gradientGroup setPosition:ccp(0+(700*j),gradientGroup.position.y)];
    }
    
    int bgoffset = 0;
    for (int i = 0; i < 2; i++) {
        CCSprite *themeBg = [themeBgs objectAtIndex:i];
        themeBg.position = ccp(themeBg.contentSize.width*i-bgoffset,themeBg.position.y);
        bgoffset = 1;
    }
    
    int offset = 0;
    for (int i = 0; i < 3; i++) {
        CCBodySprite *floor = [floors objectAtIndex:i];
        floor.position = ccp(floor.contentSize.width*i-offset, floor.position.y);
        offset = 2;
    }
    
    player.position = player.startingPoint;
    player.isLaunched = NO;
    player.isFlying = NO;
    [player removeFlame];
    [player addTouch];
}

- (void)openScoreScreen
{
    [self stopGame];
    [self setNextTheme];
    
    scoreScreen = [ScoreScene node];
    scoreScreen.position = ccp(0,screenSize.height);
    [self addChild:scoreScreen];
    
    id action = [CCMoveTo actionWithDuration:3.0f position:ccp(0,0)];
    [scoreScreen runAction:[CCSequence actions:
                            action,
                            [CCCallFunc actionWithTarget:scoreScreen selector:@selector(onTransitionFinish)],
                            nil]];
}

- (void)stopGame
{
    self.isTouchEnabled = NO;
    [player removeTouch];
}

- (void)setNextTheme
{
    int themeId = [standardUserDefaults integerForKey:@"themeId"];
    if (themeId == 3) {
        themeId = 1;
    } else {
        themeId++;
    }
    [standardUserDefaults setInteger:themeId forKey:@"themeId"];
    [standardUserDefaults synchronize];
}

- (void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSLog(@"touch began");
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    Animation *explosion = [Animation newAnimation:@"explosion.png" 
                                          Position:touchLocation 
                                         DelayTime:0.05 
                                       TotalFrames:16 
                                         SheetRows:4 
                                      SheetColumns:4 
                                        FrameWidth:64 
                                       FrameHeight:64 
                                     RepeatForever:NO];
    [self addChild:explosion z:1];
    
    if (!player.isLaunched) [self rotateCannonMouth:touchLocation];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch ended");
    //UITouch* touch = [touches anyObject];
    //CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    cannon.isRotating = NO;
    if (!player.isLaunched) {
        CCParticleSun *emitter = [CCParticleSun node];
        [emitter setEmitterMode: kCCParticleModeRadius];
        emitter.autoRemoveOnFinish = YES;
        emitter.position = player.position;
        emitter.duration = 1.0;
        emitter.endRadius = 100.0;
        [floorGroup addChild:emitter z:10];
        
        float power = cannon.power;
        float angle = CC_DEGREES_TO_RADIANS(-cannon.mouth.rotation);
        float xForce = cos(angle) * power;
        float yForce = sin(angle) * power;
        b2Vec2 force(xForce, yForce);
        player.visible = YES;
        player.physicsType = kDynamic;
        b2Vec2 b2Location(player.nodeToWorldTransform.tx / PTM_RATIO, player.nodeToWorldTransform.ty / PTM_RATIO);
        player.body->ApplyLinearImpulse(force, b2Location);
        
        if (!player.isRotating) [player rotateMe];
        player.isFlying = YES;
        player.isLaunched = YES;
    }
}

- (void) dealloc
{
    [goodies release];
    [baddies release];
    [gradientsGroups release];
    [themeBgs release];
    [floors release];
	[super dealloc];
}

- (void) onOverlapBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2
{
	// check if two boxes have started to overlap
	if (sprite1.collisionType == kFireCollisionType && sprite2.collisionType == kPlayerCollisionType) {
        
	}
}

- (void) onSeparateBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2
{
	// check if two boxes are no longer overlapping
	if (sprite1.collisionType == kFireCollisionType && sprite2.collisionType == kPlayerCollisionType) {

        // shoot player into the air when it touches the fire
        float ds = sqrtf(player.velocity.x*player.velocity.x + player.velocity.y*player.velocity.y);
        float xs = cos(CC_DEGREES_TO_RADIANS(80)) * ds + 50;
        float ys = sin(CC_DEGREES_TO_RADIANS(80)) * ds;
        [player setVelocity:ccp(xs, ys)];
        if (player.isOnFire == NO) {
            [player putPlayerOnFire];
            [floorGroup addChild:player.flame];
        } else {
            [player resetFlameTimer];
        }
        
	}
}

- (void) onCollideBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2 withForce:(float)force withFrictionForce:(float)frictionForce
{
	// check if two boxes have collided in the last update
	if (sprite1.collisionType == kFireCollisionType && sprite2.collisionType == kPlayerCollisionType) {
        
	}
}

@end
