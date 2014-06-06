//
//  MealComponentController.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 3/29/13.
//
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "MenuViewController.h"
#import "Dish.h"
#import "MenuCell.h"
#import "OrderSummaryViewController.h"
#import "TabBarController.h"
#import "ParseClient.h"
#import "AFHTTPRequestOperation.h"
#import "MenuResult.h"
#import "CreateOrLoginViewController.h"
#import "IntroViewController.h"
#import "Constants.h"
#import "Location.h"
#import <QuartzCore/QuartzCore.h>
#import <Crashlytics/Crashlytics.h>

@implementation MenuViewController

@synthesize kiosk;
@synthesize menu;

NSMutableDictionary *order;
bool foo;
NSString *location = @"";

Location *selectedLocation;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh menu..."];
    
    [refresh addTarget:self action:@selector(refreshMenu) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;

    order = [NSMutableDictionary dictionary];
}

-(void)viewWillAppear:(BOOL)animated
{
    selectedLocation = [[Location alloc] initFromFile];
    menu = [Menu current];
    menu.delegate = self;
    
    if(selectedLocation == Nil){
        UIStoryboard *storyboard = nil;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            NSLog(@"retina 4");
            storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        } else {
            NSLog(@"retina 3.5");
            storyboard = [UIStoryboard storyboardWithName:@"Storyboard35" bundle:nil];
        }
        IntroViewController *intro = (IntroViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Intro"];
        [self presentViewController:intro animated:true completion:Nil];
    } else if([menu isEmpty]){
        [menu refreshFromServerWithOverlay:FALSE];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    if(selectedLocation != nil){
        location = selectedLocation.objectId;
        [self.tableView reloadData];
    }
}

-(void)refreshMenu
{
    [menu refreshFromServerWithOverlay:false];
}

-(void)stopRefresh
{
    [self.refreshControl endRefreshing];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menu.menu count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    @try {
        LocationItem *locationItem = [menu.menu objectAtIndex:indexPath.row];
        if (![[Menu current] isQuantityAvailable:locationItem.menuItemId.objectId withQuantity:1]) {
            cell.soldOut.hidden = NO;
            [cell setUserInteractionEnabled:NO];
        } else {
            cell.soldOut.hidden = YES;
            [cell setUserInteractionEnabled:YES];
        }
        cell.name.text = locationItem.menuItemId.name;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[locationItem.menuItemId.picture stringByDeletingPathExtension] ofType:@"jpg"];
        
        if(nil != filePath){ //image found with app bundle, load into SD image cache for rest of app lifetime
            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
            [[SDImageCache sharedImageCache] storeImage:image forKey:[NSString stringWithFormat:CLOUDINARY_IMAGE_FOOD_URL,locationItem.menuItemId.picture]];
        }
        
        [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:CLOUDINARY_IMAGE_FOOD_URL,locationItem.menuItemId.picture]]];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception %@",exception.description);
    }
    
    return cell;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"MealSelect"])
	{
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
		MenuItemDetailsViewController *mealDetailsController = segue.destinationViewController;
        
        LocationItem *selectedItem = [menu.menu objectAtIndex:selectedRowIndex.row];
        
        mealDetailsController.locationItemSelected = selectedItem;
        [mealDetailsController setDelegate:self];
	}
    else if ([segue.identifier isEqualToString:@"CheckoutFromMenu"])
    {

        OrderSummaryViewController *orderController = segue.destinationViewController;
        [orderController setDelegate:self];
    }
}


- (void)setBadgeValue:(int)count;
{
    if(count == 0)
        self.parentViewController.tabBarItem.badgeValue = nil;
    else
        self.parentViewController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", count];
}

- (void)refreshFromServerCompleteWithSuccess:(BOOL)success
{
    [self.tableView reloadData]; //either reload with data from server or from local copy
    [self stopRefresh];
}

@end
