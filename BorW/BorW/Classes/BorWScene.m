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
#import "myBoundary.h"

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

static float BUTTON_FONT_SIZE = 25;
static float WHITE_CONTROL_BUTTON_X_POSITION = 0.77f;
static float WHITE_CONTROL_BUTTON_Y_POSITION = 0.05f;
static float BLACK_CONTROL_BUTTON_X_POSITION = 0.05f;
static float BLACK_CONTROL_BUTTON_Y_POSITION = 0.95f;
static int PLAYER_JUMP_DURATION = 2;
static float GRAVITY = 50.0f;

@implementation BorWScene
{
    CCSprite *_sprite_white;
    bool whiteOnTheAir;
    bool whiteOnTheOtherSide;
    
    CCSprite *_sprite_black;
    bool blackOnTheAir;
    bool blackOnTheOtherSide;
    
    CCSprite *_background;
    CCPhysicsNode *_physicsWorld;
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
    
    whiteOnTheAir = true;
    blackOnTheAir = true;
    
    whiteOnTheOtherSide = false;
    blackOnTheOtherSide = false;
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    _background = [CCSprite spriteWithImageNamed:@"LayoutFinal.png"];
    _background.anchorPoint = CGPointMake(0, 0);
    //CGSize s = [[CCDirector sharedDirector] viewSize];
    CGSize imageSize = [_background boundingBox].size;
    [_background setScaleX:(self.contentSize.width/imageSize.width)];
    [_background setScaleY:(self.contentSize.height/imageSize.height)];
    
    [self addChild:_background z:0];
    
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0, 0);
    _physicsWorld.debugDraw = NO;
    _physicsWorld.collisionDelegate = self;
    [self addChild:_physicsWorld];
    
    [myBoundary makeBoundary: _physicsWorld : self.contentSize.height : self.contentSize.width];
    
    
    // Add a sprite (white)
    _sprite_white = [CCSprite spriteWithImageNamed:@"Folk.png"];
    _sprite_white.position  = ccp(self.contentSize.width/2,self.contentSize.height/3*2);
    _sprite_white.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _sprite_white.contentSize} cornerRadius:0];
    _sprite_white.physicsBody.collisionGroup = @"player1";
    _sprite_white.physicsBody.allowsRotation = NO;
    [_physicsWorld addChild: _sprite_white];
    
    // Add another sprite (black)
    _sprite_black = [CCSprite spriteWithImageNamed:@"Folk.png"];
    _sprite_black.position  = ccp(self.contentSize.width/2, self.contentSize.height/3);
    _sprite_black.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _sprite_black.contentSize} cornerRadius:0];
    _sprite_black.physicsBody.collisionGroup = @"player2";
    _sprite_black.physicsBody.allowsRotation = NO;
    [_physicsWorld addChild: _sprite_black];
    
    // Animate sprite with action
    //CCActionRotateBy* actionSpin = [CCActionRotateBy actionWithDuration:1.5f angle:360];
    //[_sprite runAction:[CCActionRepeatForever actionWithAction:actionSpin]];
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[ Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];    
    
    // Create back buttons
    CCButton *backButton1 = [CCButton buttonWithTitle:@"[O]" fontName:@"Verdana-Bold" fontSize:18.0f];
    [backButton1 setColor:[CCColor blackColor]];
    backButton1.positionType = CCPositionTypeNormalized;
    backButton1.position = ccp(0.95f, 0.95f); // Top Right of screen
    [backButton1 setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton1];
    
    CCButton *backButton2 = [CCButton buttonWithTitle:@"[O]" fontName:@"Verdana-Bold" fontSize:18.0f];
    [backButton2 setColor:[CCColor whiteColor]];
    backButton2.positionType = CCPositionTypeNormalized;
    backButton2.position = ccp(0.05f, 0.05f); // Top Right of screen
    [backButton2 setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton2];
    
    
    [self setAllButtons];

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
    [self touchPlayerAction :touch :event];
}

-(void) touchPlayerAction: (UITouch *)touch :(UIEvent *)event
{
    CGPoint touchLoc = [touch locationInNode: self];
    
    // Log touch location
    CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(touchLoc));
}

-(void) draw
{
    [_sprite_white.physicsBody applyForce:CGPointMake(0.0, -GRAVITY)];
    [_sprite_black.physicsBody applyForce:CGPointMake(0.0, GRAVITY)];
}


// -----------------------------------------------------------------------
#pragma mark - Control Buttons
// -----------------------------------------------------------------------

- (void)setAllButtons
{
    //----------------------------------------------------------------------
    // White
    
    CCButton *forwardButton = [CCButton buttonWithTitle:@"->" fontName:@"Verdana-Bold" fontSize:BUTTON_FONT_SIZE];
    [forwardButton setColor:[CCColor whiteColor]];
    forwardButton.positionType = CCPositionTypeNormalized;
    forwardButton.position = ccp(WHITE_CONTROL_BUTTON_X_POSITION+0.18f, WHITE_CONTROL_BUTTON_Y_POSITION);
    [forwardButton setTarget:self selector:@selector(onWhiteForwardClicked:)];
    [self addChild:forwardButton];
    
    CCButton *backwordButton = [CCButton buttonWithTitle:@"<-" fontName:@"Verdana-Bold" fontSize:BUTTON_FONT_SIZE];
    [backwordButton setColor:[CCColor whiteColor]];
    backwordButton.positionType = CCPositionTypeNormalized;
    backwordButton.position = ccp(WHITE_CONTROL_BUTTON_X_POSITION+0.12f, WHITE_CONTROL_BUTTON_Y_POSITION);
    [backwordButton setTarget:self selector:@selector(onWhiteBackwardClicked:)];
    [self addChild:backwordButton];
    
    CCButton *jumpButton = [CCButton buttonWithTitle:@"||" fontName:@"Verdana-Bold" fontSize:BUTTON_FONT_SIZE];
    [jumpButton setColor:[CCColor whiteColor]];
    jumpButton.positionType = CCPositionTypeNormalized;
    jumpButton.position = ccp(WHITE_CONTROL_BUTTON_X_POSITION+0.06f, WHITE_CONTROL_BUTTON_Y_POSITION);
    [jumpButton setTarget:self selector:@selector(onWhiteJumpClicked:)];
    [self addChild:jumpButton];
    
    CCButton *flipButton = [CCButton buttonWithTitle:@"{}" fontName:@"Verdana-Bold" fontSize:BUTTON_FONT_SIZE];
    [flipButton setColor:[CCColor whiteColor]];
    flipButton.positionType = CCPositionTypeNormalized;
    flipButton.position = ccp(WHITE_CONTROL_BUTTON_X_POSITION, WHITE_CONTROL_BUTTON_Y_POSITION);
    [flipButton setTarget:self selector:@selector(onWhiteFlipClicked:)];
    [self addChild:flipButton];
    
    //----------------------------------------------------------------------
    // Black
    
    CCButton *forwardButton2 = [CCButton buttonWithTitle:@"<-" fontName:@"Verdana-Bold" fontSize:BUTTON_FONT_SIZE];
    [forwardButton2 setColor:[CCColor blackColor]];
    forwardButton2.positionType = CCPositionTypeNormalized;
    forwardButton2.position = ccp(BLACK_CONTROL_BUTTON_X_POSITION, BLACK_CONTROL_BUTTON_Y_POSITION);
    [forwardButton2 setTarget:self selector:@selector(onBlackForwardClicked:)];
    [self addChild:forwardButton2];
    
    CCButton *backwordButton2 = [CCButton buttonWithTitle:@"->" fontName:@"Verdana-Bold" fontSize:BUTTON_FONT_SIZE];
    [backwordButton2 setColor:[CCColor blackColor]];
    backwordButton2.positionType = CCPositionTypeNormalized;
    backwordButton2.position = ccp(BLACK_CONTROL_BUTTON_X_POSITION+0.06f, BLACK_CONTROL_BUTTON_Y_POSITION);
    [backwordButton2 setTarget:self selector:@selector(onBlackBackwardClicked:)];
    [self addChild:backwordButton2];
    
    CCButton *jumpButton2 = [CCButton buttonWithTitle:@"||" fontName:@"Verdana-Bold" fontSize:BUTTON_FONT_SIZE];
    [jumpButton2 setColor:[CCColor blackColor]];
    jumpButton2.positionType = CCPositionTypeNormalized;
    jumpButton2.position = ccp(BLACK_CONTROL_BUTTON_X_POSITION+0.12f, BLACK_CONTROL_BUTTON_Y_POSITION);
    [jumpButton2 setTarget:self selector:@selector(onBlackJumpClicked:)];
    [self addChild:jumpButton2];
    
    CCButton *flipButton2 = [CCButton buttonWithTitle:@"{}" fontName:@"Verdana-Bold" fontSize:BUTTON_FONT_SIZE];
    [flipButton2 setColor:[CCColor blackColor]];
    flipButton2.positionType = CCPositionTypeNormalized;
    flipButton2.position = ccp(BLACK_CONTROL_BUTTON_X_POSITION+0.18f, BLACK_CONTROL_BUTTON_Y_POSITION);
    [flipButton2 setTarget:self selector:@selector(onBlackFlipClicked:)];
    [self addChild:flipButton2];
}

//-----------------------------------------------------
- (void)onWhiteForwardClicked:(id)sender
{
    CCActionMoveBy *actionMove = [CCActionMoveBy actionWithDuration:1 position:CGPointMake(_sprite_white.contentSize.width, 0)];
    [_sprite_white runAction:actionMove];
}
- (void)onWhiteBackwardClicked:(id)sender
{
    CCActionMoveBy *actionMove = [CCActionMoveBy actionWithDuration:1 position:CGPointMake(-_sprite_white.contentSize.width, 0)];
    [_sprite_white runAction:actionMove];
}
- (void)onWhiteJumpClicked:(id)sender
{
    CCActionJumpBy *actionJump = [CCActionJumpBy actionWithDuration:PLAYER_JUMP_DURATION position:CGPointMake(0, _sprite_white.contentSize.height) height:0 jumps:1];
    [_sprite_white runAction:actionJump];
    
    [_sprite_white.physicsBody applyForce:CGPointMake(0.0, GRAVITY)];
}
- (void)onWhiteFlipClicked:(id)sender
{
    CCSprite *tmp = _sprite_white;
    _sprite_white = _sprite_black;
    _sprite_black = tmp;
}

//-----------------------------------------------------
- (void)onBlackForwardClicked:(id)sender
{
    CCActionMoveBy *actionMove = [CCActionMoveBy actionWithDuration:1 position:CGPointMake(-_sprite_black.contentSize.width, 0)];
    [_sprite_black runAction:actionMove];
}
- (void)onBlackBackwardClicked:(id)sender
{
    CCActionMoveBy *actionMove = [CCActionMoveBy actionWithDuration:1 position:CGPointMake(_sprite_white.contentSize.width, 0)];
    [_sprite_black runAction:actionMove];
}
- (void)onBlackJumpClicked:(id)sender
{
    CCActionJumpBy *actionJump = [CCActionJumpBy actionWithDuration:PLAYER_JUMP_DURATION position:CGPointMake(0, -_sprite_white.contentSize.height) height:0 jumps:1];
    [_sprite_black runAction:actionJump];

    [_sprite_black.physicsBody applyForce:CGPointMake(0.0, GRAVITY)];
}
- (void)onBlackFlipClicked:(id)sender
{
    CCSprite *tmp = _sprite_white;
    _sprite_white = _sprite_black;
    _sprite_black = tmp;
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