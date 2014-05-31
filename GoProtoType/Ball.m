//
//  Ball.m
//  GoProtoType
//
//  Created by Pminu on 5/30/14.
//  Copyright (c) 2014 LGMRA Studios. All rights reserved.
//
#import "Ball.h"

@implementation Ball

+ (Ball *) withStyle:(BallStyle)style;
{
    
    Ball *ball = [[Ball alloc] initWithImageNamed:@"dotNoOpps"];
    return ball;
}

//- (void)setBallCategory:(uint32_t)ball playerCategory:(uint32_t)player
//{
    //[self.physicsBody setCategoryBitMask:ball];
    //[self.physicsBody setCollisionBitMask:player];
//}

@end