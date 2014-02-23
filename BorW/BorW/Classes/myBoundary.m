//
//  Boundary.m
//  BorW
//
//  Created by Torres Jin on 2/22/2014.
//  Copyright (c) 2014 Torres Jin. All rights reserved.
//

#import "myBoundary.h"

static int myScale = 2;

@implementation myBoundary
{
    int type;
    CGFloat width;
    CGFloat height;
}
+ (CGFloat)min:(CGFloat)a :(CGFloat)b{
    if(a<b)
        return a;
    else
        return b;
}
+ (void)makeBoundary:(CCPhysicsNode *) physicsWorld :(CGFloat)winHeight :(CGFloat)winWidth
{
    CCSprite *_boundary[15];
    myBoundary *boundary[15];
    
    CGPoint points[2];
    for(int i=0;i<15;i++) {
        _boundary[i]=[CCSprite new];
        [physicsWorld addChild: _boundary[i]];
    }
    
    points[0].x=3;points[0].y=777;points[1].x=305;points[1].y=775;
    boundary[0]=[[myBoundary alloc]initWithPoints:points AndType:3];
    _boundary[0].position = ccp(points[0].x+boundary[0].getWidth/2,points[1].y);
    points[0].x=305;points[0].y=775;points[1].x=305;points[1].y=989;
    boundary[1]=[[myBoundary alloc]initWithPoints:points AndType:1];
    _boundary[1].position = ccp(points[0].x,[self min:points[0].y :points[1].y]+boundary[1].getHeight/2);
    points[0].x=313;points[0].y=989;points[1].x=471;points[1].y=989;
    boundary[2]=[[myBoundary alloc]initWithPoints:points AndType:3];
    _boundary[2].position = ccp(points[0].x+boundary[2].getWidth/2,points[1].y);
    points[0].x=471;points[0].y=989;points[1].x=471;points[1].y=775;
    boundary[3]=[[myBoundary alloc]initWithPoints:points AndType:1];
    _boundary[3].position = ccp(points[0].x,[self min:points[0].y :points[1].y]+boundary[3].getHeight/2);
    points[0].x=471;points[0].y=775;points[1].x=647;points[1].y=775;
    boundary[4]=[[myBoundary alloc]initWithPoints:points AndType:3];
    _boundary[4].position = ccp(points[0].x+boundary[4].getWidth/2,points[1].y);
    points[0].x=647;points[0].y=775;points[1].x=647;points[1].y=1163;
    boundary[5]=[[myBoundary alloc]initWithPoints:points AndType:1];
    _boundary[5].position = ccp(points[0].x,[self min:points[0].y :points[1].y]+boundary[5].getHeight/2);
    points[0].x=647;points[0].y=1163;points[1].x=839;points[1].y=1163;
    boundary[6]=[[myBoundary alloc]initWithPoints:points AndType:3];
    _boundary[6].position = ccp(points[0].x+boundary[6].getWidth/2,points[1].y);
    points[0].x=839;points[0].y=1163;points[1].x=839;points[1].y=775;
    boundary[7]=[[myBoundary alloc]initWithPoints:points AndType:1];
    _boundary[7].position = ccp(points[0].x,[self min:points[0].y :points[1].y]+boundary[7].getHeight/2);
    points[0].x=839;points[0].y=775;points[1].x=1007;points[1].y=775;
    boundary[8]=[[myBoundary alloc]initWithPoints:points AndType:3];
    _boundary[8].position = ccp(points[0].x+boundary[8].getWidth/2,points[1].y);
    CGPoint temp[4];
    temp[0].x=1007;temp[0].y=743;temp[1].x=1085;temp[1].y=743;
    temp[2].x=1085;temp[2].y=775;temp[3].x=1007;temp[3].y=775;
    boundary[9]=[[myBoundary alloc]initWithPoints:temp AndType:2];
    _boundary[9].position = ccp((1007+1085)/2,(743+775)/2);
    points[0].x=1085;points[0].y=775;points[1].x=1305;points[1].y=775;
    boundary[10]=[[myBoundary alloc]initWithPoints:points AndType:3];
    _boundary[10].position = ccp(points[0].x+boundary[10].getWidth/2,points[1].y);
    points[0].x=1305;points[0].y=775;points[1].x=1305;points[1].y=389;
    boundary[11]=[[myBoundary alloc]initWithPoints:points AndType:1];
    _boundary[11].position = ccp(points[0].x,[self min:points[0].y :points[1].y]+boundary[11].getHeight/2);
    points[0].x=1305;points[0].y=389;points[1].x=1501;points[1].y=399;
    boundary[12]=[[myBoundary alloc]initWithPoints:points AndType:3];
    _boundary[12].position = ccp(points[0].x+boundary[12].getWidth/2,points[1].y);
    points[0].x=1501;points[0].y=399;points[1].x=1501;points[1].y=775;
    boundary[13]=[[myBoundary alloc]initWithPoints:points AndType:1];
    _boundary[13].position = ccp(points[0].x,[self min:points[0].y :points[1].y]+boundary[13].getHeight/2);
    points[0].x=1501;points[0].y=775;points[1].x=2047;points[1].y=775;
    boundary[14]=[[myBoundary alloc]initWithPoints:points AndType:3];
    _boundary[14].position = ccp(points[0].x+boundary[14].getWidth/2,points[1].y);
    
    for(int i=0;i<15;i++){
        _boundary[i].position = CGPointMake(_boundary[i].position.x / myScale,winHeight - _boundary[i].position.y / myScale);
        _boundary[i].contentSize=CGSizeMake(boundary[i].getWidth/myScale,boundary[i].getHeight/myScale);
        
        _boundary[i].physicsBody=[CCPhysicsBody bodyWithRect:(CGRect){CGPointZero,_boundary[i].contentSize} cornerRadius:0];
        switch([boundary[i] getType]){
            case 1:_boundary[i].physicsBody.collisionType = @"verticalBoundaryGroup";break;
            case 2:_boundary[i].physicsBody.collisionType = @"spikeBoundaryGroup";break;
            case 3:_boundary[i].physicsBody.collisionType = @"horizontalBoundaryGroup";break;
            default:break;
        }
    }
    CCSprite *lBoundary=[CCSprite new];
    lBoundary.position = CGPointMake(0, winHeight/2);
    lBoundary.contentSize = CGSizeMake(10, winHeight);
    lBoundary.physicsBody=[CCPhysicsBody bodyWithRect:(CGRect){CGPointZero,lBoundary.contentSize} cornerRadius:0];
    lBoundary.physicsBody.mass=900000000000000000000000000000.00;
    [physicsWorld addChild:lBoundary];
}

- (CGFloat)abs:(CGFloat)a{
    if(a<0){
        return -a;
    }
    return a;
}
- (id) initWithPoints:(CGPoint [])allPoints AndType:(int)wall{
    id result=[super init];
    if(wall==HORIZONTAL) {
        width=[self abs:allPoints[1].x-allPoints[0].x];
        height=10;
    }
    else if(wall==VERTICAL) {
        height=[self abs:(allPoints[1].y-allPoints[0].y)];
        width=10;
    }
    else if(wall==SPIKE) {
        width=[self abs:(allPoints[1].x-allPoints[0].x)];
        height=[self abs:(allPoints[2].y-allPoints[1].y)];
    }
    type=wall;
    return result;
}
-(int)getType {
    return type;
}
-(CGFloat)getHeight {
    return height;
}
-(CGFloat)getWidth {
    return width;
}
@end
