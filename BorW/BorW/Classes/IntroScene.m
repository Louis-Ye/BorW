//
//  IntroScene.m
//  BorW
//
//  Created by Torres Jin on 2/22/2014.
//  Copyright Torres Jin 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "BorWScene.h"
#import "NewtonScene.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);

    long randNum = random();

    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[self getColarByNum:(randNum)]];
    [self addChild:background];
    
    
    // Hello world
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Black or White" fontName:@"Chalkduster" fontSize:36.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [self getAnotherColarByNum:(randNum)];
    label.position = ccp(0.5f, 0.5f); // Middle of screen
    [self addChild:label];
    
    // Spinning scene button
    CCButton *gameStartButton = [CCButton buttonWithTitle:@"[ Start Game ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    
    [gameStartButton setColor:[self getAnotherColarByNum:(randNum)]];
    gameStartButton.positionType = CCPositionTypeNormalized;
    gameStartButton.position = ccp(0.5f, 0.35f);
    [gameStartButton setTarget:self selector:@selector(onSpinningClicked:)];
    [self addChild:gameStartButton];

    /*
    // Next scene button
    CCButton *newtonButton = [CCButton buttonWithTitle:@"[ Newton Physics ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    newtonButton.positionType = CCPositionTypeNormalized;
    newtonButton.position = ccp(0.5f, 0.20f);
    [newtonButton setTarget:self selector:@selector(onNewtonClicked:)];
    [self addChild:newtonButton];
     */
	
    // done
	return self;
}

- (CCColor *) getColarByNum : (long)num
{
    if (num % 2 == 0) return [CCColor whiteColor];
    else return [CCColor blackColor];
}

- (CCColor *) getAnotherColarByNum : (long)num
{
    if (num % 2 == 0) return [CCColor blackColor];
    else return [CCColor whiteColor];
}
                               

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onSpinningClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[BorWScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

- (void)onNewtonClicked:(id)sender
{
    // start newton scene with transition
    // the current scene is pushed, and thus needs popping to be brought back. This is done in the newton scene, when pressing back (upper left corner)
    [[CCDirector sharedDirector] pushScene:[NewtonScene scene]
                            withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

// -----------------------------------------------------------------------
@end
