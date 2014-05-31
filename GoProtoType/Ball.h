//
//  Ball.h
//  GoProtoType
//
//  Created by Pminu on 5/30/14.
//  Copyright (c) 2014 LGMRA Studios. All rights reserved.
//
#import <SpriteKit/SpriteKit.h>


typedef NS_ENUM(NSInteger, BallStyle)
{
    BallBody
};

@interface Ball: SKSpriteNode


+ (Ball *) withStyle:(BallStyle)style;

//-(void)setBallCategory:(uint32_t)ball playerCategory:(uint32_t)player;

@end
