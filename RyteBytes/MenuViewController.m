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
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>
#import <Crashlytics/Crashlytics.h>

/** This class presents the user the current menu.  It will retrieve the current list of MenuItems (db objects & domain objects)
 via a REST call.  We will persist all items we have offered via our menu, but we will not persist snapshots of our menu.
 
 When this class loads, it will make a REST call to see when the current menu went live and compare it to the local copy that it
 has.  If the cloud one is newer, it will retrieve the full list and update the menu.
 */
@implementation MenuViewController

@synthesize kiosk;
@synthesize menu;

NSMutableDictionary *order;
bool foo;
NSString *location = @"";

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
    menu = [Menu current];
    [menu refreshFromServerWithOverlay:FALSE];

    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    
    [refresh addTarget:self action:@selector(refreshMenu) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;

    order = [NSMutableDictionary dictionary];
}

-(void)viewWillAppear:(BOOL)animated
{
    menu.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    NSString *newLocation = [[Menu current] getLocationId];
    if(![location isEqualToString:newLocation]){
        location = newLocation;
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
        MenuItem *menuItem = [menu.menu objectAtIndex:indexPath.row];
        if (![[Menu current] isQuantityAvailableWithMenuItemId:menuItem.objectId withQuantity:1]) {
            cell.soldOut.hidden = NO;
            [cell setUserInteractionEnabled:NO];
        } else {
            cell.soldOut.hidden = YES;
            [cell setUserInteractionEnabled:YES];
        }
        cell.name.text = menuItem.name;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[menuItem.picture stringByDeletingPathExtension] ofType:@"jpg"];
        
        if(nil != filePath){ //image found with app bundle, load into SD image cache for rest of app lifetime
            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
            [[SDImageCache sharedImageCache] storeImage:image forKey:[NSString stringWithFormat:CLOUDINARY_IMAGE_FOOD_URL,menuItem.picture]];
        }
        
        [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:CLOUDINARY_IMAGE_FOOD_URL,menuItem.picture]]];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception %@",exception.description);
//        [[[UIAlertView alloc] initWithTitle:@"Invalid selection."
//                                    message:@"There was an error finding an item for this location. Please return to the menu screen and refresh the menu by pulling down - thanks!"
//                                   delegate:nil
//                          cancelButtonTitle:@"Okay"
//                          otherButtonTitles:nil] show];
    }
    
    

    return cell;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"MealSelect"])
	{
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
		MenuItemDetailsViewController *mealDetailsController = segue.destinationViewController;
        
        MenuItem *selectedMeal = [menu.menu objectAtIndex:selectedRowIndex.row];
        
        mealDetailsController.menuItemSelected = selectedMeal;
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
