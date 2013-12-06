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
@synthesize menuItems;

NSMutableDictionary *order;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(menuItems == NULL)
    {
        [self refreshMenu];
    }
    
    NSLog(@"The current order is : %@",((TabBarController*)(self.tabBarController)).currentOrder);
    
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    
    [refresh addTarget:self action:@selector(refreshMenu) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    order = [NSMutableDictionary dictionary];
}

-(void)refreshMenu
{
    ParseClient *parseClient = [ParseClient current];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [parseClient POST:RetrieveMenu parameters:[[NSDictionary alloc] init]
          success:^(NSURLSessionDataTask *task , id responseObject) {
              NSError *error = nil;
              menuItems = [[MenuResult alloc] initWithDictionary:responseObject error:&error].result;
              [[Order current] setupOrderWithMenu:menuItems];
              [self.tableView reloadData];
              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
              [self stopRefresh];
          } failure:^(NSURLSessionDataTask *operation, NSError *error) {
              NSLog(@"Error returned retrieving menu %@", [error localizedDescription]);
              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
              [self stopRefresh];
              [[[UIAlertView alloc] initWithTitle:@"Error connecting."
                                          message:@"There was an error connecting to our servers - please try again."
                                         delegate:nil
                                cancelButtonTitle:@"Okay"
                                otherButtonTitles:nil] show];
              
          }
     ];
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
    return [self.menuItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
    
    MenuItem *meal = [self.menuItems objectAtIndex:indexPath.row];
//    cell.name.text = meal.name;
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
            //            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            //            CreateOrLoginViewController *cl = (CreateOrLoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SignIn"];
            //            cl.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            //            [self presentViewController:cl animated:true completion:Nil];
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
        
        MenuItem *selectedMeal = [self.menuItems objectAtIndex:selectedRowIndex.row];
        
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
        else{
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//            CreateOrLoginViewController *cl = (CreateOrLoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SignIn"];
//            cl.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//            [self presentViewController:cl animated:true completion:Nil];
            TabBarController *tab = (TabBarController*)self.parentViewController.parentViewController;
            [tab showLogin];
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


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
//     ConfirmOrderController *orderController = [[ConfirmOrderController alloc]];
     // ...
     // Pass the selected object to the new view controller.
//     [self.navigationController pushViewController:detailViewController animated:YES];
    
}

@end
