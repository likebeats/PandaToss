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
        
        //masterBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"pandatoss.pvr.ccz"];
        //[self addChild:masterBatchNode];
        
        screenSize = [CCDirector sharedDirector].winSize;
        globalVars = [GlobalVars get];
        
        [self initScene];
        
        // TO DEBUG PHYSICS
        //[self addChild:[[GB2DebugDrawLayer alloc] init] z:30];
        
	}
	return self;
}

- (void) initScene
{
    int themeId = [standardUserDefaults integerForKey:@"themeId"];
    NSString *theme_name = [globalVars.themeNames objectAtIndex:themeId];
    
    int cannonId = [standardUserDefaults integerForKey:@"cannonId"];
    NSString *cannon_name = [globalVars.cannonFileNames objectAtIndex:cannonId];
    
    gunId = [standardUserDefaults integerForKey:@"gunId"];
    gunPower = [[globalVars.gunPowers objectAtIndex:gunId] integerValue];
    gunAmmo = [[globalVars.gunAmmos objectAtIndex:gunId] integerValue];
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
        CCSprite *themeBg = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@.png", theme_name]];
        themeBg.position = ccp(themeBg.contentSize.width*i-bgoffset,themeBg.contentSize.height/2+75-1); // 75 is height of floor
        [themeBgs addObject:themeBg];
        [bgGroup addChild:themeBg];
        bgoffset = 1;
    }
    
    floors = [[NSMutableArray alloc] initWithCapacity:3];
    int offset = 0;
    for (int i = 0; i < 3; i++) {
        GB2Sprite *floor = [GB2Sprite spriteWithStaticBody:@"floor" spriteFrameName:[NSString stringWithFormat:@"%@_floor.png", theme_name]];
        floor.ccPosition = ccp(floor.ccNode.contentSize.width*i-offset, floor.ccNode.contentSize.height/2);
        [floors addObject:floor];
        [floorGroup addChild:[floor ccNode]];
        offset = 2;
    }
    
    player = [[Player alloc] initNewPlayer];
    [floorGroup addChild:[player ccNode]];
    
    //GB2Node *leftWall = [[GB2Node alloc] initWithStaticBody:nil node:[[CCNode alloc] init]];
    //[leftWall addEdgeFrom:b2Vec2FromCC(0, 0) to:b2Vec2FromCC(0, 320)];
    //[floorGroup addChild:leftWall.ccNode];
    
    cannon = [Cannon cannonWithName:cannon_name StartingPosition:player.startingPoint];
    cannon.position = player.ccPosition;
    [floorGroup addChild:cannon];
    
    fallLine = cannon.position.y-20;
    
    [self addChild:bgGroup];
    [self addChild:floorGroup];
    
    [self createHUD];
    
    // enable the frame scheduler
    [self schedule:@selector(enterFrame:)];
}

- (void) createHUD
{
    NSString *gunFileName = [globalVars.gunFileNames objectAtIndex:gunId];
    
    int nextY = screenSize.height-60;
    for (int i=0; i<gunAmmo; i++) {
        CCSprite *ammo = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"ammo_%@",gunFileName]];
        ammo.anchorPoint = ccp(0,0.5);
        ammo.position = ccp(15,nextY);
        nextY = ammo.position.y-ammo.contentSize.height;
        [self addChild:ammo];
    }
    
    [self createLabels];
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
    
    labelsGroup.position = ccp(330,-230);
    [self addChild:labelsGroup];
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
    
    //[self spawnGoodies];
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
            floor.ccPosition = ccp(newX-offset,floor.ccPosition.y);
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
        
        if((playerLocalx - groupLocalx) >= (screenSize.width*2)+100) {
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
        
        if((playerLocalx - themeBgLocalx) >= (screenSize.width*2)+100) {
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
            if ((player.position.x - animation.sprite.position.x) > 700) {
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
            if ((player.position.x - animation.sprite.position.x) > 700) {
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
    player.ccPosition = ccp(playerNewX,playerNewY);
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
    themeId++;
    if (themeId == 3) {
        themeId = 0;
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
        [player applyLinearImpulse:force point:[player worldCenter]];
        
        if (!player.isRotating) [player rotateMe];
        player.isFlying = YES;
        player.isLaunched = YES;
    }
    
}

@end
