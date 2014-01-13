//
//  OrderController.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 5/11/13.
//
//

#import "OrderSummaryViewController.h"
#import "OrderNotifications.h"
#import "OrderSummaryCell.h"
#import "MenuItem.h"
#import "OrderItem.h"
#import "Order.h"
#import "Constants.h"
#import "ParseClient.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"
#import "TabBarController.h"
#import "Location.h"
#import "CloudinaryClient.h"
#import "SDWebImageManager.h"

@implementation OrderSummaryViewController

@synthesize orderSummary;
@synthesize orderTotal;
@synthesize location;

Order *currentOrder;
NSMutableArray *orderArray;
int orderTotalCost = 0;
OrderItem *selectedItem;
Location *pickupLocation;
PFUser *currentUser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    currentOrder = [Order current];
    orderArray = [currentOrder convertToOrderItemArray];
    
    [orderSummary reloadData];
    [self updateOrderCost];
}

-(void)viewWillAppear:(BOOL)animated
{
    currentUser = [PFUser currentUser];
    pickupLocation = [[Location alloc] initFromFile];
    location.text = pickupLocation.name;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [currentOrder getNumberUniqueItems];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    OrderSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderSummaryCell" forIndexPath:indexPath];
    
    OrderItem *item = [orderArray objectAtIndex:indexPath.row];
    cell.itemName.text = [item.menuItem.name uppercaseString];
    cell.stepper.value = item.quantity;
    cell.uniqueId = item.menuItem.objectId;
//    cell.image.image = [[manager imageCache] imageFromDiskCacheForKey:@"pasta_od9dqk.jpg"];
    cell.image.image = [UIImage imageNamed:item.menuItem.picture];
    [cell.image setClipsToBounds:YES];
    cell.itemQuantityAndCost.text =
        [NSString stringWithFormat:@"%d x $%d = $%.02f", item.quantity, item.menuItem.costInCents / 100, [item calculateCost]];
  
    return cell;
}

- (IBAction)valueChanged:(UIStepper *)sender {
    int value = [sender value];
    OrderSummaryCell *cell = (OrderSummaryCell*)[[[sender superview] superview] superview];
    selectedItem = [currentOrder getOrderItem:cell.uniqueId];
    
    if(![currentOrder setMenuItem:selectedItem.menuItem withQuantity:value]){
        sender.value--;
        [[[UIAlertView alloc] initWithTitle:@"No more left"
                                    message:[NSString stringWithFormat:@"There are no more %@ left to purchase at this location.",selectedItem.menuItem.name]
                                   delegate:self
                          cancelButtonTitle:nil
                          otherButtonTitles:@"Okay", nil] show];
        
    } else {
        if(0 == value) {
            [[[UIAlertView alloc] initWithTitle:@"Remove item?"
                                        message:@"The quantity for this item is 0 - would you like to remove it from the cart?"
                                       delegate:self
                              cancelButtonTitle:@"Yes" //index = 0
                              otherButtonTitles:@"No", nil] show];
        }
        cell.itemQuantityAndCost.text = [NSString stringWithFormat:@"%d x $%d = $%.02f", value, selectedItem.menuItem.costInCents / 100, [selectedItem calculateCost]];
        [self.delegate setBadgeValue:[currentOrder getTotalItemCount]];
        orderArray = [currentOrder convertToOrderItemArray];
        [self updateOrderCost];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex && [alertView.title isEqualToString:@"Remove item?"]) { //remove from cart
        [currentOrder removeOrderItem:selectedItem];
        [orderSummary reloadData];
    }
}

- (void)updateOrderCost {
    orderTotal.text = [NSString stringWithFormat:@"$%.02f", [currentOrder calculateTotalOrderCost]];
}

- (IBAction)placeOrder:(id)sender
{
    Order *order = [Order current];
    
    if([order getTotalItemCount] < 1)
    {
        [[[UIAlertView alloc] initWithTitle:@"Nothing in cart."
                                    message:@"Please add one or more items to your cart."
                                   delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil] show];
    }
    else
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        order.userId = [[PFUser currentUser] objectId];
        order.locationId = [[[PFUser currentUser] valueForKey:@"locationId"] objectId];
        order.totalInCents = [order calculateTotalOrderCostInCents];
        
        NSDictionary *o = [order toDictionary];
        NSLog(@"Order : %@",o);
        
        [[ParseClient current] POST:PlaceOrder parameters:[order toDictionary]
                success:^(NSURLSessionDataTask *operation, id responseObject) {
                    NSLog(@"placed order succesfully, message : %@", responseObject);
                    [SVProgressHUD dismiss];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    [order clearEntireOrder];
                    [[[UIAlertView alloc] initWithTitle:@"Success!"
                                                message:@"Enjoy your dinner - a receipt will be emailed to you shortly!"
                                               delegate:nil
                                      cancelButtonTitle:@"Okay"
                                      otherButtonTitles:nil] show];
                    NSArray *viewControllers = self.navigationController.viewControllers;
                    MenuViewController *rootViewController = (MenuViewController*)[viewControllers objectAtIndex:0];
                    [rootViewController setBadgeValue:0];
                    
                    [self.navigationController popToRootViewControllerAnimated:TRUE];
                }
                failure:^(NSURLSessionDataTask *operation, NSError *error) {
                    NSLog(@"placed order failing, message : %@", [error localizedDescription]);
                    [SVProgressHUD dismiss];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                }
         ];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
