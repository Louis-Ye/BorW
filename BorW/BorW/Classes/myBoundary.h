//
//  Boundary.h
//  BorW
//
//  Created by Torres Jin on 2/22/2014.
//  Copyright (c) 2014 Torres Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d-ui.h"
#import "cocos2d.h"

static int VERTICAL=1, SPIKE=2, HORIZONTAL=3;
@interface myBoundary : NSObject
// -----------------------------------------------------------------------
+ (void)makeBoundary:(CCPhysicsNode *) physicsWorld :(CGFloat)winHeight :(CGFloat)winWidth;
- (id) initWithPoints:(CGPoint [])allPoints AndType:(int)wall;
- (CGFloat)getWidth;
- (CGFloat)getHeight;
- (int)getType;
// -----------------------------------------------------------------------
@end
