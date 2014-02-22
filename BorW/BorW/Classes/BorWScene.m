//
//  HelloWorldScene.m
//  BorW
//
//  Created by Torres Jin on 2/22/2014.
//  Copyright Torres Jin 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "BorWScene.h"
#import "IntroScene.h"
#import "NewtonScene.h"

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation BorWScene
{
    CCSprite *_sprite;
    CCSprite *_background;
    CCPhysicsNode *_physicsWorld;
    CCSprite *_boundary[100];
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (BorWScene *)scene
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
    
    _background = [CCSprite spriteWithImageNamed:@"BowLayout.png"];
    _background.anchorPoint = CGPointMake(0, 0);
    //CGSize s = [[CCDirector sharedDirector] viewSize];
    CGSize imageSize = [_background boundingBox].size;
    [_background setScaleX:(self.contentSize.width/imageSize.width)];
    [_background setScaleY:(self.contentSize.height/imageSize.height)];
    [self addChild:_background];
    
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    _physicsWorld.debugDraw = YES;
    _physicsWorld.collisionDelegate = self;
    [self addChild:_physicsWorld];
    
    // Add a sprite
    _sprite = [CCSprite spriteWithImageNamed:@"Folk.png"];
    _sprite.position  = ccp(0,self.contentSize.height/2);
    _sprite.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _sprite.contentSize} cornerRadius:0];
    _sprite.physicsBody.collisionGroup = @"player1";
    [_physicsWorld addChild: _sprite];
    
    // Animate sprite with action
    //CCActionRotateBy* actionSpin = [CCActionRotateBy actionWithDuration:1.5f angle:360];
    //[_sprite runAction:[CCActionRepeatForever actionWithAction:actionSpin]];
    
    _boundary[0] = [CCSprite new];
    _boundary[0].position = ccp(0,self.contentSize.height/4);
    _boundary[0].contentSize= (CGSize){100.0,1.0};
    _boundary[0].physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _boundary[0].contentSize} cornerRadius:0];
    _boundary[0].physicsBody.collisionGroup = @"boundaryGroup";
    [_physicsWorld addChild: _boundary[0]];
    
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
    
    // Log touch location
    CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(touchLoc));
    
    // Move our sprite to touch location
    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:1.0f position:touchLoc];
    [_sprite runAction:actionMove];
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
@end