//
//  MealComponentController.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 3/29/13.
//
//

#import "PickMealViewController.h"
#import "Dish.h"
#import "MenuCell.h"
#import "MealDetailsViewController.h"
#import "OrderSummaryViewController.h"
#import "TabBarController.h"
#import "ParseClient.h"
#import "AFHTTPRequestOperation.h"

/** This class present the user the current menu.  It will retrieve the current list of MenuItems (db objects & domain objects)
 via a REST call.  We will persist all items we have offered via our menu, but we will not persist snapshots of our menu.
 
 When this class loads, it will make a REST call to see when the current menu went live and compare it to the local copy that it
 has.  If the cloud one is newer, it will retrieve the full list and update the menu.
 */
@implementation PickMealViewController

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
    
    ParseClient *parseClient = [ParseClient current];
    
    [parseClient postPath:RetrieveMenu parameters:[[NSDictionary alloc] init]
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      NSLog(@"Successful response from retrievemenu : %@).", responseObject);
                      menuItems = [MenuItem convertMenuJsonToMenuItemArray:responseObject];
                      [self.tableView reloadData];
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"Error returned retrieving menu %@", [error localizedDescription]);
                  }];
    
    NSLog(@"The current order is : %@",((TabBarController*)(self.tabBarController)).currentOrder);

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    order = [NSMutableDictionary dictionary];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)generateMenuData {
    menuItems = [NSMutableArray arrayWithCapacity:3];
    
    //MealComponent *p = [[MealComponent alloc] initWithName:@"Turkey Meatballs" withDescription:@"All the flavor with nearly none of the fat" withType:Protein withPrice:2.99 withNutritionInfo:NULL];
//    MealComponent* s = [[MealComponent alloc] initWithName:@"Homemade Whole Wheat Linguine" withDescription:@"Our homemade, whole wheat flour and egg linguine." withType:Starch withPrice:2.99 withNutritionInfo:NULL];
  //  MealComponent* v = [[MealComponent alloc] initWithName:@"Italian Gravy" withDescription:@"Our gravy - as the Italians call it - would make even the Godfather smile." withType:Vegetable withPrice:2.99 withNutritionInfo:NULL];
//    
//    Dish* mob = [[Dish alloc]initWithName:@"Mob Meal I" withDescription:@"A meal fit for a king...or Godfather." withProtein:p withStarch:s withVeg:v withImage:@"OrderScreenchick_taters_shrooms.png"];
//
//    Dish* chicken = [[Dish alloc]initWithName:@"Mob Meal I" withDescription:@"A meal fit for a king...or Godfather." withProtein:p withStarch:s withVeg:v withImage:@"OrderScreenCreateAMeal.png"];
//
//    menuItems[0] = mob;
//    menuItems[1] = chicken;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
    
    Dish *meal = [self.menuItems objectAtIndex:indexPath.row];
    
    cell.name.text = meal.name;
//    cell.image.image = [UIImage imageNamed:meal.imageName];
    
    return cell;
}


-(void) addMealToOrder:(NSString *)meal withCount:(int)count
{
    if(count == 0)
    {
        [order removeObjectForKey:meal];
        self.parentViewController.tabBarItem.badgeValue = nil;
    }
    else
    {
        [order setObject:[NSNumber numberWithInt:count] forKey:meal];
        self.parentViewController.tabBarItem.badgeValue = [[order objectForKey:meal] stringValue];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"MealSelect"])
	{
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
		MealDetailsViewController *mealDetailsController = segue.destinationViewController;
        
        Dish *selectedMeal = [self.menuItems objectAtIndex:selectedRowIndex.row];
        
        mealDetailsController.mealToOrder = selectedMeal;
        [mealDetailsController setDelegate:self];
//        if (nil == [order objectForKey:selectedMeal.name]) {
//            confirmOrderController.currentAmountOrdered = @"0";
//        }
//        else{
//            confirmOrderController.currentAmountOrdered = [[order objectForKey:selectedMeal.name] stringValue];
//        } 
	}
    else if ([segue.identifier isEqualToString:@"Checkout"])
    {
        OrderSummaryViewController *orderController = segue.destinationViewController;
        orderController.order = order;
    }
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
