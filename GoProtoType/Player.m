//
//  Player.m
//  GoProtoType
//
//  Created by Pminu on 5/30/14.
//  Copyright (c) 2014 LGMRA Studios. All rights reserved.
//

#import "Player.h"

@interface Player()
@property (strong,nonatomic) SKAction * moveLeft;
@property (strong,nonatomic) SKAction * moveRight;
@end
/*bit masks*/
static const uint32_t playererCategory = 0x1 << 0;
static const uint32_t ballCategory = 0x1 << 1;

/*static floats*/
static const CGFloat dbDensity = 1.15;

@implementation Player

- (id)init
{
    if (self = [super init])
    {
        CGSize body = CGSizeMake(25,10);
        self = [Player spriteNodeWithImageNamed:@"playerPiece"];
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:body];
        [self.physicsBody setAffectedByGravity:FALSE];
        [self.physicsBody setDensity:dbDensity];
        [self.physicsBody setAllowsRotation:NO];
        [self.physicsBody setCategoryBitMask:playererCategory];
        [self.physicsBody setContactTestBitMask:ballCategory];
        [self.physicsBody setCollisionBitMask:ballCategory];
        self.name = @"player";
        self.moveLeft = [SKAction moveTo:CGPointMake(self.position.x-75, self.position.y) duration:.5];
        self.moveRight = [SKAction moveTo:CGPointMake(self.position.x+75, self.position.y) duration:.5];
    }
    return self;
}
@end
