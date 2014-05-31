//
//  GOBoardScene.m
//  GoProtoType
//
//  Created by Pminu on 5/27/14.
//  Copyright (c) 2014 LGMRA Studios. All rights reserved.
//

#import "GOBoardScene.h"
#import "Ball.h"
#import "Player.h"

@interface GOBoardScene()
@property (nonatomic, strong) NSMutableArray *dots;
@end

static const CGFloat posA = 80;
static const CGFloat posB = 160;
static const CGFloat posC = 240;
static const CGFloat Xpos = 650;
/* static ints */
static const NSInteger closed = 0;
static const NSInteger opened = 0;
static const NSInteger line1 = 0;
static const NSInteger line2 = 1;
static const NSInteger line3 = 2;
static const NSInteger arc2 = 2;
static const NSInteger arc3 = 3;
static NSInteger dotSpawnInterval = 60;
@implementation GOBoardScene
{
    SKSpriteNode *movingBack1;
    SKSpriteNode *movingBack2;
    SKEmitterNode *burstEmitter;
    Player *_player;
    Ball * _ball;
    SKLabelNode *scoreLabel;
    //NSInteger dotSpawnInterval;
    NSInteger _shakeTimer;
    NSInteger _dotCountDecrementTimer;
    //NSInteger dotCountDecrementTimerLimiter;
    NSInteger _gameTimer;
    NSInteger _hueTimer;
    NSInteger _brightTimer;
    NSInteger _backImageCounter;
    
    NSInteger dotSpawnIntervalP;
    NSInteger _shakeTimerP;
    NSInteger _dotCountDecrementTimerP;
    NSInteger _gameTimerP;
    NSInteger _hueTimerP;
    NSInteger _brightTimerP;
    NSArray *_album;
    
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
}

/* static bools */
static bool changeBG = NO;
static bool lastLineEmpty = NO;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Board Scene Loaded!";
        myLabel.fontSize = 20;
        myLabel.fontColor = [UIColor magentaColor];
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
        //set to center of page first page
        movingBack1 = [SKSpriteNode spriteNodeWithImageNamed:@"background4"];
        movingBack1.position = CGPointMake(self.size.width/2, self.size.height/2);
        //set to middle of imaginary page above
        movingBack2 = [SKSpriteNode spriteNodeWithImageNamed:@"background4"];
        movingBack2.position = CGPointMake(self.size.width/2, (self.size.height * 2) - (self.size.height/2));
        [self addChild:movingBack1];
        [self addChild:movingBack2];
        [self createPlayer];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.position = location;
        
        //SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        //[sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    [self animateBackground:currentTime];
    [self updateDots:currentTime];
}
-(void)animateBackground:(CFTimeInterval)currentTime
{
    movingBack1.position = CGPointMake(self.size.width/2, movingBack1.position.y-2);
    movingBack2.position = CGPointMake(self.size.width/2, movingBack2.position.y-2);
    
    if (movingBack1.position.y <= -(self.size.height/2))
    {
        movingBack1.position = CGPointMake(self.size.width/2, self.size.height+(self.size.height/2));
    }
    else if (movingBack2.position.y <= -(self.size.height/2))
    {
        movingBack2.position = CGPointMake(self.size.width/2,  self.size.height+(self.size.height/2));
    }
}
- (void)updateDots:(NSTimeInterval)currentTime
{
    /*
     -- THIS IS WHERE THE DOTS ARE CREATED, MOVED AND DELETED --
     1 - update timers
     2 - generate random numbers
     3 - using random numbers try to create a dot
     4 - check for to many or not enough dots
     5 - generate the dots
     6 - remove dots past player
     7 - update the score
     8 - update the BOOLS
     9 - reset the timers
     REPEAT
     */
    //if (game){
        _gameTimer++;
        if ( _gameTimer>dotSpawnInterval ){
            [self spawnDot];
            _gameTimer = closed;
        }
        [self removeMoveDotUpdateScore];
    //}
}
- (void) spawnDot
{
    changeBG = YES;
    NSInteger tryA = arc4random_uniform(arc2);
    NSInteger tryB = arc4random_uniform(arc2);
    NSInteger tryC = arc4random_uniform(arc2);
    if (tryA == closed && tryB == closed && tryC == closed) {
        changeBG = NO;
        NSInteger whatToRemove = arc4random_uniform(arc3);
        if (whatToRemove == line1){
            if (tryB == closed){[self createDot:posB];}
            if (tryC == closed){[self createDot:posC];}
        }else if (whatToRemove == line2){
            if (tryA == closed){[self createDot:posA];}
            if (tryC == closed){[self createDot:posC];}
        }else if (whatToRemove == line3){
            if (tryA == closed){[self createDot:posA];}
            if (tryB == closed){[self createDot:posB];}
        }
    }else if (tryA == opened && tryB == opened && tryC == opened) {
        if (lastLineEmpty){
            NSInteger whatToRemove = arc4random_uniform(arc3);
            if (whatToRemove == line1){
                if (tryB == closed){[self createDot:posB];}
                if (tryC == closed){[self createDot:posC];}
            }else if (whatToRemove == line2){
                if (tryA == closed){[self createDot:posA];}
                if (tryC == closed){[self createDot:posC];}
            }else if (whatToRemove == line3){
                if (tryA == closed){[self createDot:posA];}
                if (tryB == closed){[self createDot:posB];}
            }
            lastLineEmpty = NO;
        }else{
            lastLineEmpty = YES;
        }
    }else{
        if (tryA == closed){[self createDot:posA];}
        if (tryB == closed){[self createDot:posB];}
        if (tryC == closed){[self createDot:posC];}
    }
}
-(void)createDot:(NSInteger)Ypos
{
    Ball *dotBod = [Ball withStyle:BallBody];
    //[dotBod setBallCategory:ballCategory playerCategory:playererCategory];
    [dotBod setPosition:CGPointMake(Ypos, Xpos)];
    //dotBod.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:dotBod.size.width*0.1];
    //[dotBod.physicsBody setAffectedByGravity:TRUE];
    //[dotBod.physicsBody setDensity:dbDensity];
    //[dotBod.physicsBody setAllowsRotation:NO];
    NSString *burstPath = [[NSBundle mainBundle] pathForResource:@"MyParticle" ofType:@"sks"];
    burstEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
    //burstEmitter.position = dotBod.position;
    
    [dotBod addChild:burstEmitter];
    dotBod.alpha = 1;
    dotBod.name = @"dotBod";
    [self addChild:dotBod];
}
- (void) removeMoveDotUpdateScore
{
    [self enumerateChildNodesWithName:@"dotBod" usingBlock:^(SKNode *node, BOOL *stop) {
        if(node.position.y < _player.position.y){
            //self.score += 1;
            _shakeTimer ++;
            _dotCountDecrementTimer ++;
            //scoreLabel.text = [NSString stringWithFormat:@"%lu",(long)self.score];
            [node removeFromParent];
        }else{
            node.position = CGPointMake(node.position.x, node.position.y-2);
            //burstEmitter.position = node.position;
        }
    }];
}
- (void) createPlayer
{
    _player = [[Player alloc]init];
    //if (Is3_5Inches())
    //{
        _player.position = CGPointMake(self.size.width/2, self.size.height/8); //dev = -4
    //}
    //else
    //{
      //  _player.position = CGPointMake(self.size.width/2, self.size.height/4);
    //}
    [self addChild:_player];
    
}
@end
