//
//  HelloWorldScene.m
//  Cocos2d01
//
//  Created by Torres Jin on 2/11/2014.
//  Copyright Torres Jin 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "HelloWorldScene.h"
#import "IntroScene.h"
#import "NewtonScene.h"

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation HelloWorldScene
{
    CCSprite *_sprite;
    CCPhysicsNode *_physicsWorld;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1.0f]];
    [self addChild:background];
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    _physicsWorld.debugDraw = NO;
    _physicsWorld.collisionDelegate = self;
    [self addChild:_physicsWorld];
    
    // Add a sprite
    _sprite = [CCSprite spriteWithImageNamed:@"player.png"];
    _sprite.position  = ccp(self.contentSize.width/2,self.contentSize.height/2);
    _sprite.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _sprite.contentSize} cornerRadius:0];
    _sprite.physicsBody.collisionGroup = @"playerGroup";
    [_physicsWorld addChild:_sprite];
    //[self addChild:_sprite];
    
    // Animate sprite with action
    CCActionRotateBy* actionSpin = [CCActionRotateBy actionWithDuration:1.5f angle:360];
    [_sprite runAction:[CCActionRepeatForever actionWithAction:actionSpin]];
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[ Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];

    // done
	return self;
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Pr frame update is automatically enabled, if update is overridden
    [self schedule:@selector(addMonster:) interval:1.5];
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    
/*  // Log touch location
*   CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(touchLoc));
*
*   // Move our sprite to touch location
*   CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:1.0f position:touchLoc];
*    [_sprite runAction:actionMove];
*/
    CGPoint offset    = ccpSub(touchLoc, _sprite.position);
    float   ratio     = offset.y/offset.x;
    int     targetX   = _sprite.contentSize.width/2 + self.contentSize.width;
    int     targetY   = (targetX*ratio) + _sprite.position.y;
    CGPoint targetPosition = ccp(targetX,targetY);
    
    // 3
    CCSprite *projectile = [CCSprite spriteWithImageNamed:@"projectile.png"];
    projectile.position = _sprite.position;
    projectile.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:projectile.contentSize.width/2.0f andCenter:projectile.anchorPointInPoints];
    projectile.physicsBody.collisionGroup = @"playerGroup";
    projectile.physicsBody.collisionType  = @"projectileCollision";
    [_physicsWorld addChild:projectile];
    
    // 4
    CCActionMoveTo *actionMove   = [CCActionMoveTo actionWithDuration:1.5f position:targetPosition];
    CCActionRemove *actionRemove = [CCActionRemove action];
    [projectile runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

- (void)onNewtonClicked:(id)sender
{
    [[CCDirector sharedDirector] pushScene:[NewtonScene scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

// -----------------------------------------------------------------------
- (void)addMonster:(CCTime)dt {
    
    CCSprite *monster = [CCSprite spriteWithImageNamed:@"monster.png"];
    
    // 1
    int minY = monster.contentSize.height / 2;
    int maxY = self.contentSize.height - monster.contentSize.height / 2;
    int rangeY = maxY - minY;
    int randomY = (arc4random() % rangeY) + minY;
    
    // 2
    monster.position = CGPointMake(self.contentSize.width + monster.contentSize.width/2, randomY);
    monster.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, monster.contentSize} cornerRadius:0];
    monster.physicsBody.collisionGroup = @"monsterGroup";
    monster.physicsBody.collisionType  = @"monsterCollision";
    [_physicsWorld addChild:monster];
    //[self addChild:monster];
    
    // 3
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
    // 4
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(-monster.contentSize.width/2, randomY)];
    CCAction *actionRemove = [CCActionRemove action];
    [monster runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair monsterCollision:(CCNode *)monster projectileCollision:(CCNode *)projectile {
    [monster removeFromParent];
    [projectile removeFromParent];
    return YES;
}
@end