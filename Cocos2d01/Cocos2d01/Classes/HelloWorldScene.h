//
//  HelloWorldScene.h
//  Cocos2d01
//
//  Created by Torres Jin on 2/11/2014.
//  Copyright Torres Jin 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using Cocos2D v3
#import "cocos2d.h"
#import "cocos2d-ui.h"

// -----------------------------------------------------------------------

/**
 *  The main scene
 */
@interface HelloWorldScene : CCScene <CCPhysicsCollisionDelegate>

// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene;
- (id)init;
- (void)addMonster:(CCTime)dt;

// -----------------------------------------------------------------------
@end