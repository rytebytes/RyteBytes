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
#import "ParseError.h"
#import "JSONResponseSerializerWithData.h"
#import <SDWebImage/UIImageView+WebCache.h>

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
NSNumberFormatter *formatter;

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
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [Order current].delegate = self;
    [orderSummary reloadData];
    [self updateOrderCost];
}

-(void)viewWillAppear:(BOOL)animated
{
    currentUser = [PFUser currentUser];
    pickupLocation = [[Location alloc] initFromFile];
    location.text = pickupLocation.name;
    [self checkForOutOfStockItems];
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
    OrderSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderSummaryCell" forIndexPath:indexPath];
    
    OrderItem *item = [orderArray objectAtIndex:indexPath.row];
    cell.itemName.text = [item.menuItem.name uppercaseString];
    cell.stepper.value = item.quantity;
    cell.uniqueId = item.menuItem.objectId;
    [cell.image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:CLOUDINARY_IMAGE_FOOD_URL,item.menuItem.picture]]];
    [cell.image setClipsToBounds:YES];
    
    
    NSNumber *totalItemCost = [NSNumber numberWithFloat:[item calculateCost]];
    NSNumber *itemUnitCost = [NSNumber numberWithFloat:item.menuItem.costInCents / 100.0];
    
    cell.quantityAndUnitCost.text = [NSString stringWithFormat:@"%d x %@ = ", item.quantity, [formatter stringFromNumber:itemUnitCost]];
    cell.totalItemCost.text = [formatter stringFromNumber:totalItemCost];
    
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
        
        selectedItem = [[Order current] getOrderItem:selectedItem.menuItem.objectId];
        
        NSNumber *totalItemCost = [NSNumber numberWithFloat:[selectedItem calculateCost]];
        NSNumber *itemUnitCost = [NSNumber numberWithFloat:selectedItem.menuItem.costInCents / 100.0];
        int quantity = selectedItem.quantity;
        cell.quantityAndUnitCost.text = [NSString stringWithFormat:@"%d x %@ = ", quantity, [formatter stringFromNumber:itemUnitCost]];
        cell.totalItemCost.text = [formatter stringFromNumber:totalItemCost];
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
    NSNumber *totalOrderCost = [NSNumber numberWithFloat:[currentOrder calculateTotalOrderCost]];
    orderTotal.text = [formatter stringFromNumber:totalOrderCost];
}

-(void)checkForOutOfStockItems{
    NSString *list = [[Order current] checkForOutOfStockItems];
    if([list length] > 0){
        [SVProgressHUD dismiss];
        [[[UIAlertView alloc] initWithTitle:@"Items out of stock!"
                                    message:[list stringByAppendingString:@" have been removed from your order. Return to the menu screen to see what's available."]
                                   delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil] show];
    }
    orderArray = [[Order current] convertToOrderItemArray];
    [self.delegate setBadgeValue:[currentOrder getTotalItemCount]];
    [orderSummary reloadData];
    [self updateOrderCost];
}

-(void)orderUpdatedWithNewMenu {
    [SVProgressHUD showWithStatus:@"Checking order against your location's menu!" maskType:SVProgressHUDMaskTypeGradient];
    [self checkForOutOfStockItems];
    [SVProgressHUD dismiss];
}

- (IBAction)placeOrder:(id)sender
{
    PFUser *currentUser = [PFUser currentUser];
    if (!currentUser)
    {
        TabBarController *tab = (TabBarController*)self.parentViewController.parentViewController;
        //false because when the menu refreshes it will call order's delegate which is this class
        //this class will show a HUD and check the order against the current menu
        [tab showLoginDismissHUDOnSuccess:FALSE];
    }
    else if([[Order current] getTotalItemCount] < 1)
    {
        [[[UIAlertView alloc] initWithTitle:@"Nothing in cart."
                                    message:@"Please add one or more items to your cart."
                                   delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil] show];
    }
    else if([[currentUser valueForKey:STRIPE_ID] hasPrefix:@"tok"])
    {
        [[PFUser currentUser] refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                NSLog(@"Refreshing user from Parse completed.");
                if(nil == error){
                    [self sendOrderToParse];
                } else {
                    [[[UIAlertView alloc] initWithTitle:@"Error."
                                                message:@"There was an error placing your order, please try again."
                                               delegate:nil
                                      cancelButtonTitle:@"Okay"
                                      otherButtonTitles:nil] show];
                }
            }
         ];
    }
    else
    {
        [self sendOrderToParse];
    }
    
}

-(void)sendOrderToParse
{
    Order *order = [Order current];
    
    [SVProgressHUD showWithStatus:@"Placing Order" maskType:SVProgressHUDMaskTypeGradient];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    order.userId = [[PFUser currentUser] objectId];
    order.locationId = [[[PFUser currentUser] valueForKey:@"locationId"] objectId];
    order.totalInCents = [order calculateTotalOrderCostInCents];
    
    NSDictionary *o = [order toDictionary];
    NSLog(@"Order : %@",o);
    
    [[ParseClient current] POST:PlaceOrder parameters:[order toDictionary]
            success:^(NSURLSessionDataTask *operation, id responseObject) {
                NSLog(@"placed order succesfully, message : %@", responseObject);
                [[Menu current] refreshFromServerWithOverlay:FALSE];
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
                NSError *modelConversionError;
                [SVProgressHUD dismiss];
                NSLog(@"placed order failing, message : %@", [error localizedDescription]);
                NSString *info = error.userInfo[JSONResponseSerializerWithDataKey];
                ParseError *parseError = [[ParseError alloc] initWithString:info error:&modelConversionError];
                [[[UIAlertView alloc] initWithTitle:@"Error"
                                            message:[parseError extractMessage]
                                           delegate:nil
                                  cancelButtonTitle:@"Okay"
                                  otherButtonTitles:nil] show];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [[Menu current] refreshFromServerWithOverlay:TRUE];
//                        [self checkForOutOfStockItems];
            }
     ];
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
