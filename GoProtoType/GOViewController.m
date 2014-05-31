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
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong)SKView *skView;
@property (nonatomic, strong)SKScene *boardScene;
@property (nonatomic, strong)SKScene *startScene;
@property (nonatomic, strong)SKScene *mapScene;
@end


@implementation GOViewController
//{
//    NSMutableArray *data;
//}

@synthesize responseData = _responseData;
@synthesize data = _data;

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
    [self loadTableDataInBackground];
}

- (IBAction)buttonPressed:(id)sender
{
    //101==back-102==board
    if ([sender tag] == 101)
    {
        if (![self.skView.scene.name  isEqual: @"start"])
        {
            self.tableView.alpha = 0;
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
            self.tableView.alpha = 0;
            // Create the Board Scene.
            self.boardScene = [GOBoardScene sceneWithSize:self.skView.bounds.size];
            self.boardScene.scaleMode = SKSceneScaleModeAspectFill;
            self.boardScene.name = @"board";
            [self.skView presentScene:self.boardScene];
        }
    }
    else if ([sender tag] == 103)
    {
        if (!self.tableView.alpha == 1)
        {
            //try showing the scroll view
            if ([self.data count] > 0)
            {
                [self updateTable];
                self.tableView.alpha = 1;
            }
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


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)datas {
    [self.responseData appendData:datas];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    // show all values
    for(id key in res) {
        
        id value = [res objectForKey:key];
        
        
        NSString *keyAsString = (NSString *)key;
        NSString *valueAsString = (NSString *)value;
        
        NSLog(@"key: %@", keyAsString);
        NSLog(@"value: %@", valueAsString);
    }
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    //alloc the data array...
    //data = [[NSMutableArray alloc]init];

    // extract specific value...
    NSArray *results = [res objectForKey:@"results"];
    
    for (NSDictionary *result in results) {
        NSString *icon = [result objectForKey:@"icon"];
        NSLog(@"icon: %@", icon);
        
        //here I re-use the key in res and append to the tableView
        NSString *name = [result objectForKey:@"name"];
        NSLog(@"name: %@", name);
        [self.data addObject:name];
    }
    //self.data = [[NSMutableArray alloc]initWithArray:tempArray];
    NSLog(@"finished getting data......data count: %lu", (unsigned long)[self.data count]);
}

- (void) loadTableDataInBackground
{
    //hide table view/init table data array
    UIImage *back = [UIImage imageNamed:@"background4"];
    self.tableView.alpha = 0;
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:back];
    self.data = [[NSMutableArray alloc]init];
    
    self.responseData = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:@"https://maps.googleapis.com/maps/api/place/search/json?location=-33.8670522,151.1957362&radius=500&types=food&name=harbour&sensor=false&key=YOUR_API_KEY"]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void) updateTable
{
    [self.tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.opaque = NO;
    }
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.imageView.image = [UIImage imageNamed:@"iconLogo"];
    cell.textLabel.text = [self.data objectAtIndex:indexPath.row];
    return cell;
}
@end
