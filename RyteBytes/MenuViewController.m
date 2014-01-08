//
//  MealComponentController.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 3/29/13.
//
//

#import "MenuViewController.h"
#import "Dish.h"
#import "MenuCell.h"
#import "OrderSummaryViewController.h"
#import "TabBarController.h"
#import "ParseClient.h"
#import "AFHTTPRequestOperation.h"
#import "MenuResult.h"
#import "CreateOrLoginViewController.h"

/** This class presents the user the current menu.  It will retrieve the current list of MenuItems (db objects & domain objects)
 via a REST call.  We will persist all items we have offered via our menu, but we will not persist snapshots of our menu.
 
 When this class loads, it will make a REST call to see when the current menu went live and compare it to the local copy that it
 has.  If the cloud one is newer, it will retrieve the full list and update the menu.
 */
@implementation MenuViewController

@synthesize kiosk;
@synthesize menu;

NSMutableDictionary *order;

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
    menu.delegate = self;
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    
    [refresh addTarget:self action:@selector(refreshMenu) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;

    order = [NSMutableDictionary dictionary];
}

-(void)viewWillAppear:(BOOL)animated
{
    if([menu.menu count] == 0)
    {
        [menu refreshFromServerWithOverlay:true];
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
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
    
    MenuItem *meal = [menu.menu objectAtIndex:indexPath.row];
    cell.image.image = [UIImage imageNamed:meal.picture];
    
    return cell;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"CheckoutFromMenu"])
    {
        PFUser *currentUser = [PFUser currentUser];
        if (currentUser)
        {
            return YES;
        }
        else{
            TabBarController *tab = (TabBarController*)self.parentViewController.parentViewController;
            [tab showLogin];
            return NO;
        }
    }
    return YES;
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
        //check if the user is logged in, if not, ask them to login or create an account
        PFUser *currentUser = [PFUser currentUser];
        if (currentUser)
        {
            OrderSummaryViewController *orderController = segue.destinationViewController;
            [orderController setDelegate:self];
        }
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
