//
//  GOViewController.m
//  GoProtoType
//
//  Created by Pminu on 5/27/14.
//  Copyright (c) 2014 LGMRA Studios. All rights reserved.
//

#import "GOViewController.h"
#import "GOMyScene.h"
#import "GOBoardScene.h"
#import "GOMapScene.h"
@interface GOViewController()
@property (retain, nonatomic) UIButton *backButton;
@property (retain, nonatomic) UIButton *boardButton;
@property (retain, nonatomic) UIButton *mapButton;

@property (nonatomic, strong)SKView *skView;
@property (nonatomic, strong)SKScene *boardScene;
@property (nonatomic, strong)SKScene *startScene;
@property (nonatomic, strong)SKScene *mapScene;
@end
@implementation GOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"view loaded");
    // Configure the view.
    self.skView = (SKView *)self.view;
    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
    
    // Create and configure the initial Start Scene.
    self.startScene = [GOMyScene sceneWithSize:self.skView.bounds.size];
    self.startScene.scaleMode = SKSceneScaleModeAspectFill;
    self.startScene.name = @"start";
    
    //customize the buttons
    self.backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.backButton setTitle:@"Start Scene" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backButton setBackgroundColor:[UIColor blueColor]];
    [self.backButton setContentEdgeInsets:UIEdgeInsetsMake(2, 6, 2, 6)];
    self.backButton.center = CGPointMake(CGRectGetMidX(self.skView.frame)-100, 50);
    [self.backButton sizeToFit];
    self.backButton.tag = 101;
    [self.backButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
    
    self.boardButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.boardButton setTitle:@"Board Scene" forState:UIControlStateNormal];
    [self.boardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.boardButton setBackgroundColor:[UIColor blueColor]];
    [self.boardButton setContentEdgeInsets:UIEdgeInsetsMake(2, 6, 2, 6)];
    self.boardButton.center = CGPointMake(CGRectGetMidX(self.skView.frame), 50);
    [self.boardButton sizeToFit];
    self.boardButton.tag = 102;
    [self.boardButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
    
    self.mapButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.mapButton setTitle:@"Map Scene" forState:UIControlStateNormal];
    [self.mapButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.mapButton setBackgroundColor:[UIColor blueColor]];
    [self.mapButton setContentEdgeInsets:UIEdgeInsetsMake(2, 6, 2, 6)];
    self.mapButton.center = CGPointMake(CGRectGetMidX(self.skView.frame)-50, 100);
    [self.mapButton sizeToFit];
    self.mapButton.tag = 103;
    [self.mapButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
    
    //Attach the buttons to the view
    [self.skView addSubview:self.backButton];
    [self.skView addSubview:self.boardButton];
    [self.skView addSubview:self.mapButton];
    
    // Present the scene.
    [self.skView presentScene:self.startScene];
}

- (IBAction)buttonPressed:(id)sender
{
    //101==back-102==board
    if ([sender tag] == 101)
    {
        if (![self.skView.scene.name  isEqual: @"start"])
        {
            // Create the Start Scene.
            self.startScene = [GOMyScene sceneWithSize:self.skView.bounds.size];
            self.startScene.scaleMode = SKSceneScaleModeAspectFill;
            self.startScene.name = @"start";
            [self.skView presentScene:self.startScene];
        }
    }
    else if ([sender tag] == 102)
    {
        if (![self.skView.scene.name  isEqual: @"board"])
        {
            // Create the Board Scene.
            self.boardScene = [GOBoardScene sceneWithSize:self.skView.bounds.size];
            self.boardScene.scaleMode = SKSceneScaleModeAspectFill;
            self.boardScene.name = @"board";
            [self.skView presentScene:self.boardScene];
        }
    }
    else if ([sender tag] == 103)
    {
        if (![self.skView.scene.name  isEqual: @"map"])
        {
            // Create the Board Scene.
            self.mapScene = [GOMapScene sceneWithSize:self.skView.bounds.size];
            self.mapScene.scaleMode = SKSceneScaleModeAspectFill;
            self.mapScene.name = @"map";
            [self.skView presentScene:self.mapScene];
        }
    }
}
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
