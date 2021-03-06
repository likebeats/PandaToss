//
//  GameScene.mm
//  TossThePanda
//
//  Created by Manpreet on 6/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

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
        [standardUserDefaults synchronize];
        
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = NO;
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"pandatoss.plist"];
        
        [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"shapes.plist"];
        
        masterBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"pandatoss.pvr.ccz"];
        [self addChild:masterBatchNode];
        
        screenSize = [CCDirector sharedDirector].winSize;
        screenSizeInPixels = [CCDirector sharedDirector].winSizeInPixels;
		
        [self initScene];
        
	}
	return self;
}

- (void) initScene
{
    NSString *theme_name;
    int themeId = [standardUserDefaults integerForKey:@"themeId"];
    if (themeId == 0) {
        theme_name = @"bamboo";
    } else if (themeId == 1) {
        theme_name = @"forest";
    } else if (themeId == 2) {
        theme_name = @"desert";
    }
    
    NSString *cannon_name;
    int cannonId = [standardUserDefaults integerForKey:@"cannonId"];
    if (cannonId == 0) {
        cannon_name = @"wood";
    } else if (cannonId == 1) {
        cannon_name = @"metal";
    } else if (cannonId == 2) {
        cannon_name = @"gold";
    } else if (cannonId == 3) {
        cannon_name = @"tank";
    }
    
    gunId = [standardUserDefaults integerForKey:@"gunId"];
    //gunPower = [[[AppDelegate get].gunPowers objectAtIndex:gunId] integerValue];
    //gunAmmo = [[[AppDelegate get].gunAmmos objectAtIndex:gunId] integerValue];
    gunAmmosLeft = gunAmmo;
    
    xnew = 0;
    
    goodBall = 0;
    goodTime = 20;
    newGoodTime = 30;
    
    floorGroup = [[CCNode alloc] init];
    bgGroup = [[CCNode alloc] init];
    
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
        CCSprite *themeBg = [CCSprite spriteWithSpriteFrameName:[theme_name stringByAppendingString:@".png"]];
        themeBg.position = ccp(themeBg.contentSize.width*i-bgoffset,themeBg.contentSize.height/2+75-1); // 75 is height of floor
        [themeBgs addObject:themeBg];
        [bgGroup addChild:themeBg];
        bgoffset = 1;
    }
    
    
    floors = [[NSMutableArray alloc] initWithCapacity:3];
    int offset = 0;
    for (int i = 0; i < 3; i++) {
        GB2Sprite *floor = [GB2Sprite spriteWithStaticBody:@"floor" spriteFrameName:[theme_name stringByAppendingString:@"_floor.png"]];
        [floor setPhysicsPosition:b2Vec2FromCC(floor.ccNode.contentSize.width*i-offset, floor.ccNode.contentSize.height/2)];
        [floors addObject:floor];
        [masterBatchNode addChild:[floor ccNode]];
        //[floorGroup addChild:[floor ccNode]];
        offset = 2;
        
        /*CCBodySprite *floor = [CCBodySprite spriteWithFile:[theme_name stringByAppendingString:@"_floor.png"]];
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
        offset = 2;*/
    }
    
    player = [Player newPlayer];
    [floorGroup addChild:[player ccNode]];
    
    cannon = [Cannon cannonWithName:cannon_name StartingPosition:player.startingPoint];
    cannon.position = player.ccPosition;
    [floorGroup addChild:cannon];
    
    fallLine = cannon.position.y-20;
    
    [self addChild:bgGroup];
    //[masterBatchNode addChild:floorGroup];
    
    //[self createGUI];
    [self createLabels];
    
    // enable the frame scheduler
    [self schedule:@selector(enterFrame:)];
}

- (void) createGUI
{
    /*NSString *gunFileName = [[AppDelegate get].gun_file_names objectAtIndex:gunId];
    CCSprite *ammo1 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"ammo_%@",gunFileName]];
    CCSprite *ammo2 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"ammo_%@",gunFileName]];
    CCSprite *ammo3 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"ammo_%@",gunFileName]];
    ammo1.position = ccp(25,screenSize.height-60);
    ammo2.position = ccp(25,ammo1.position.y-ammo1.contentSize.height);
    ammo3.position = ccp(25,ammo2.position.y-ammo1.contentSize.height);
    [self addChild:ammo1];
    [self addChild:ammo2];
    [self addChild:ammo3];*/
}

- (void) createLabels
{
    CCNode *labelsGroup = [CCNode node];
    
    CCLabelTTF *powerLabel = [CCLabelTTF labelWithString:@"Power:" fontName:@"Chalkduster" fontSize: 14];
    [powerLabel setAnchorPoint:CGPointZero];
    [powerLabel setPosition:ccp(10,screenSize.height-20)];
    [powerLabel setColor:ccc3(255, 0, 255)];
    [labelsGroup addChild:powerLabel];
    
    powerValue = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize: 14];
    [powerValue setAnchorPoint:CGPointZero];
    [powerValue setPosition:ccp(85,screenSize.height-20)];
    [powerValue setColor:ccc3(255, 0, 255)];
    [labelsGroup addChild:powerValue];
    
    CCLabelTTF *distanceLabel = [CCLabelTTF labelWithString:@"Distance:" fontName:@"Chalkduster" fontSize: 14];
    [distanceLabel setAnchorPoint:CGPointZero];
    [distanceLabel setPosition:ccp(10,screenSize.height-40)];
    [distanceLabel setColor:ccc3(255, 0, 255)];
    [labelsGroup addChild:distanceLabel];
    
    distanceValue = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize: 14];
    [distanceValue setAnchorPoint:CGPointZero];
    [distanceValue setPosition:ccp(85,screenSize.height-40)];
    [distanceValue setColor:ccc3(255, 0, 255)];
    [labelsGroup addChild:distanceValue];
    
    CCLabelTTF *heightLabel = [CCLabelTTF labelWithString:@"Height:" fontName:@"Chalkduster" fontSize: 14];
    [heightLabel setAnchorPoint:CGPointZero];
    [heightLabel setPosition:ccp(10,screenSize.height-60)];
    [heightLabel setColor:ccc3(255, 0, 255)];
    [labelsGroup addChild:heightLabel];
    
    heightValue = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize: 14];
    [heightValue setAnchorPoint:CGPointZero];
    [heightValue setPosition:ccp(85,screenSize.height-60)];
    [heightValue setColor:ccc3(255, 0, 255)];
    [labelsGroup addChild:heightValue];
    
    CCLabelTTF *velocityLabel = [CCLabelTTF labelWithString:@"Velocity:" fontName:@"Chalkduster" fontSize: 14];
    [velocityLabel setAnchorPoint:CGPointZero];
    [velocityLabel setPosition:ccp(10,screenSize.height-80)];
    [velocityLabel setColor:ccc3(255, 0, 255)];
    [labelsGroup addChild:velocityLabel];
    
    velocityValue = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize: 14];
    [velocityValue setAnchorPoint:CGPointZero];
    [velocityValue setPosition:ccp(85,screenSize.height-80)];
    [velocityValue setColor:ccc3(255, 0, 255)];
    [labelsGroup addChild:velocityValue];
    
    [self addChild:labelsGroup];
    labelsGroup.position = ccp(330,-230);
}

- (void) enterFrame: (ccTime)dt
{
    NSString *distance = [NSString stringWithFormat:@"%.0f", player.ccPosition.x - player.startingPoint.x];
    [distanceValue setString:distance];
    
    NSString *velocity = [NSString stringWithFormat:@"%.0f, %.0f", player.linearVelocity.x, player.linearVelocity.y];
    [velocityValue setString:velocity];
    
    NSString *height = [NSString stringWithFormat:@"%.0f", player.ccPosition.y];
    [heightValue setString:height];
    
    if (!cannon.isRotating) [self moveCamera];
    [self repositionFloors];
    [self repositionGradientBgs];
    [self repositionThemeBgs];
    
    [self spawnGoodies];
    [self spawnBaddies];
    [self removeOffScreenObjects];
    
    // Check when player stops/slows player down at low velocity
    BOOL checkPlayerStop = [player checkIfPlayerStops:[[floors objectAtIndex:0] ccPosition].y];
    [player controlPlayerFire];
    [player controlRotating:dt];
    
    if (checkPlayerStop == YES && roundDone == NO) {
        roundDone = YES;
        [self openScoreScreen];
    }
}

- (void) moveCamera
{
    int newX, newY;
    
    // move floorGroup
    newX = (-player.ccPosition.x + screenSize.width/2);
    if (player.ccPosition.y > 160) {
        newY = (-player.ccPosition.y + screenSize.height/2);
    } else {
        newY = floorGroup.position.y;
    }
    [floorGroup setPosition:ccp( newX, newY )];
    
    // move bgGroup
    newX = (-player.ccPosition.x + screenSize.width/2)/5;
    if (player.ccPosition.y > 160) {
        newY = (-player.ccPosition.y + screenSize.height/2);
    } else {
        newY = bgGroup.position.y;
    }
    [bgGroup setPosition:ccp( newX, newY )];
}

- (void) repositionFloors
{
    int next;
    int offset = 2;
    for (int i = 0; i < 3; i++) {
        if (i == 0) next = 1;
        else if (i == 1) next = 2;
        else if (i == 2) next = 0;
        GB2Sprite *floor = [floors objectAtIndex:i];
        GB2Sprite *nextfloor = [floors objectAtIndex:next];
        
        if ((player.ccPosition.x - floor.ccPosition.x) >= 480) {
            int newX = nextfloor.ccPosition.x+floor.ccNode.contentSize.width;
            [floor setPhysicsPosition:b2Vec2FromCC(newX-offset,floor.ccPosition.y)];
        }
    }
}

- (void) repositionGradientBgs
{
    int next;
    for (int i = 0; i < 2; i++) {
        if (i == 0) next = 1;
        else if (i == 1) next = 0;
        CCNode *group = [gradientsGroups objectAtIndex:i];
        CCNode *nextGroup = [gradientsGroups objectAtIndex:next];
        
        int groupLocalx = group.nodeToWorldTransform.tx;
        int playerLocalx = player.ccNode.nodeToWorldTransform.tx;
        
        if((playerLocalx - groupLocalx) >= (screenSizeInPixels.width*2)+100) {
            int newX = nextGroup.position.x+700;
            [group setPosition:ccp(newX,group.position.y)];
        }
    }
}

- (void) repositionThemeBgs
{
    int next;
    int bgoffset = 1;
    for (int i = 0; i < 2; i++) {
        if (i == 0) next = 1;
        else if (i == 1) next = 0;
        CCSprite *themeBg = [themeBgs objectAtIndex:i];
        CCSprite *nextThemeBg = [themeBgs objectAtIndex:next];
        
        int themeBgLocalx = themeBg.nodeToWorldTransform.tx;
        int playerLocalx = player.ccNode.nodeToWorldTransform.tx;
        
        if((playerLocalx - themeBgLocalx) >= (screenSizeInPixels.width*2)+100) {
            int newX = nextThemeBg.position.x+themeBg.contentSize.width;
            [themeBg setPosition:ccp(newX-bgoffset,themeBg.position.y)];
        }
    }
}

- (void) spawnGoodies
{
    if (goodTime < 1 && player.ccPosition.x > goodBall + 150)
    {
        int spawnedAll = 5;
        xnew = player.ccPosition.x + 800;
        if ((arc4random() % 30) == 0 && spawnedAll > 0)
        {
            NSLog(@"spawning campfire");
            xnew = xnew + (150 + (arc4random() % 300));
            
            /*Animation *campFire = [Animation newAnimationWithBody:@"campfire.png"
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
            [goodies addObject:campFire];*/
            
            spawnedAll--;
        }
        goodBall = player.ccPosition.x;
        goodTime = newGoodTime;
    }
    goodTime--;
}

- (void) spawnBaddies
{
    
}

- (void) removeOffScreenObjects
{
    CCNode *object;
    CCARRAY_FOREACH(goodies, object) {
        /*BOOL test = [object isKindOfClass:[Animation class]];
        if (test) {
            Animation *animation = (Animation*)object;
            if ((player.ccPosition.x - animation.sprite.position.x) > 700) {
                [animation removeAnimation];
                [goodies removeObject:animation];
            }
        } else {*/
            GB2Sprite *sprite = (GB2Sprite*)object;
            if ((player.ccPosition.x - sprite.ccPosition.x) > 700) {
                [sprite deleteNow];
                [goodies removeObject:sprite];
            }
        //}
    }
    
    CCARRAY_FOREACH(goodies, object) {
        /*BOOL test = [object isKindOfClass:[Animation class]];
        if (test) {
            Animation *animation = (Animation*)object;
            if ((player.ccPosition.x - animation.sprite.position.x) > 700) {
                [animation removeAnimation];
                [goodies removeObject:animation];
            }
        } else {*/
            GB2Sprite *sprite = (GB2Sprite*)object;
            if ((player.ccPosition.x - sprite.ccPosition.x) > 700) {
                [sprite deleteNow];
                [goodies removeObject:sprite];
            }
        //}
    }
}

- (void) rotateCannonMouth: (CGPoint)touch
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
    [player setPhysicsPosition:b2Vec2FromCC(playerNewX,playerNewY)];
}

- (void) reset // NOT USED
{
    /*roundDone = NO;
    self.isTouchEnabled = YES;
    [self removeChild:scoreScreen cleanup:YES];
    //[self removeChild:menuScreen cleanup:YES];
    //player.physicsType = kStatic;
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
    [player addTouch];*/
}

- (void) openScoreScreen
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

- (void) stopGame
{
    self.isTouchEnabled = NO;
    [player removeTouch];
}

- (void) setNextTheme
{
    int themeId = [standardUserDefaults integerForKey:@"themeId"];
    if (themeId == 3) {
        themeId = 1;
    } else {
        themeId++;
    }
    [standardUserDefaults setInteger:themeId forKey:@"themeId"];
}

- (void) onPlayerTouch
{
    NSLog(@"Player was touched!");
}

- (void) ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSLog(@"touch began");
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    /*Animation *explosion = [Animation newAnimation:@"explosion.png"
                                          Position:touchLocation 
                                         DelayTime:0.05 
                                       TotalFrames:16 
                                         SheetRows:4 
                                      SheetColumns:4 
                                        FrameWidth:64 
                                       FrameHeight:64 
                                     RepeatForever:NO];
    [self addChild:explosion z:1];*/
    
    if (!player.isLaunched) [self rotateCannonMouth:touchLocation];
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch ended");
    //UITouch* touch = [touches anyObject];
    //CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    cannon.isRotating = NO;
    if (!player.isLaunched) {
        CCParticleSun *emitter = [CCParticleSun node];
        [emitter setEmitterMode: kCCParticleModeRadius];
        emitter.autoRemoveOnFinish = YES;
        emitter.position = player.ccPosition;
        emitter.duration = 1.0;
        emitter.endRadius = 100.0;
        [floorGroup addChild:emitter z:10];
        
        float power = cannon.power;
        float angle = CC_DEGREES_TO_RADIANS(-cannon.mouth.rotation);
        float xForce = cos(angle) * power;
        float yForce = sin(angle) * power;
        b2Vec2 force(xForce, yForce);
        player.ccNode.visible = YES;
        [player setBodyType:b2_dynamicBody];
        //b2Vec2 b2Location(player.nodeToWorldTransform.tx / PTM_RATIO, player.nodeToWorldTransform.ty / PTM_RATIO);
        //player.body->ApplyLinearImpulse(force, b2Location);
        [player applyLinearImpulse:force point:[player worldCenter]];
        
        if (!player.isRotating) [player rotateMe];
        player.isFlying = YES;
        player.isLaunched = YES;
    }
}

/*- (void) onOverlapBody:(CCBodySprite *)sprite1 andBody:(CCBodySprite *)sprite2
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
}*/

@end
