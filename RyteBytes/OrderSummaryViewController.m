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
#import "CouponValidateResult.h"
#import "CouponValidation.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation OrderSummaryViewController

@synthesize orderSummary;
@synthesize orderTotal;
@synthesize location;
@synthesize coupon;

Order *currentOrder;
NSMutableArray *orderArray;
int orderTotalCost = 0;
OrderItem *selectedItem;
Location *pickupLocation;
PFUser *currentUser;
NSNumberFormatter *formatter;
CouponValidation *couponEntered;

NSInteger COUPON_ALERT_TAG = 1;
NSInteger REMOVE_ITEM_ALERT_TAG = 2;
NSInteger COUPON_REMOVE_TAG = 3;

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
    
    NSMutableAttributedString *couponBtnString = [[NSMutableAttributedString alloc] initWithString:@"Apply Coupon"];
    
    [couponBtnString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [couponBtnString length])];
    
    [coupon setAttributedTitle:couponBtnString forState:UIControlStateNormal];
    
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
    if([Order current].couponValidateResult != NULL && [Order current].couponValidateResult.valid){
        [self updateOrderCost];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (IBAction)enterCoupon:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    if([Order current].couponValidateResult != NULL && [Order current].couponValidateResult.valid == TRUE){
        UIAlertView *removeCoupon = [[UIAlertView alloc] initWithTitle:@"Remove" message:@"Would you like to remove the coupon from your order?" delegate:self cancelButtonTitle:@"Remove" otherButtonTitles:@"Cancel", nil];
        [removeCoupon setTag:COUPON_REMOVE_TAG];
        [removeCoupon show];
    }
    else if (currentUser)
    {
        UIAlertView *couponAlert = [[UIAlertView alloc] initWithTitle:@"Coupon" message:@"Please enter the coupon code below" delegate:self cancelButtonTitle:@"Apply" otherButtonTitles:@"Cancel",nil];
        couponAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [couponAlert textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        [couponAlert setTag:COUPON_ALERT_TAG];
        [couponAlert show];
    }
    else
    {
        TabBarController *tab = (TabBarController*)self.parentViewController.parentViewController;
        [tab showLoginDismissHUDOnSuccess:TRUE];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [currentOrder getNumberUniqueItems];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderSummaryCell" forIndexPath:indexPath];
    
    OrderItem *item = [orderArray objectAtIndex:indexPath.row];
    cell.itemName.text = [item.locationItem.menuItemId.name uppercaseString];
    cell.stepper.value = item.quantity;
    cell.uniqueId = item.locationItem.menuItemId.objectId;
    [cell.image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:CLOUDINARY_IMAGE_FOOD_URL,item.locationItem.menuItemId.picture]]];
    [cell.image setClipsToBounds:YES];
    
    
    NSNumber *totalItemCost = [NSNumber numberWithFloat:[item calculateCost]];
    NSNumber *itemUnitCost = [NSNumber numberWithFloat:item.locationItem.costInCents / 100.0];
    
    cell.quantityAndUnitCost.text = [NSString stringWithFormat:@"%d x %@ = ", item.quantity, [formatter stringFromNumber:itemUnitCost]];
    cell.totalItemCost.text = [formatter stringFromNumber:totalItemCost];
    
    return cell;
}

- (IBAction)valueChanged:(UIStepper *)sender {
    int value = [sender value];
    OrderSummaryCell *cell = (OrderSummaryCell*)[[[sender superview] superview] superview];
    selectedItem = [currentOrder getOrderItem:cell.uniqueId];
    
    if(![currentOrder setLocationItem:selectedItem.locationItem withQuantity:value]){
        sender.value--;
        [[[UIAlertView alloc] initWithTitle:@"No more left"
                                    message:[NSString stringWithFormat:@"There are no more %@ left to purchase at this location.",selectedItem.locationItem.menuItemId.name]
                                   delegate:self
                          cancelButtonTitle:nil
                          otherButtonTitles:@"Okay", nil] show];
        
    } else {
        if(0 == value) {
            UIAlertView *removeItem = [[UIAlertView alloc] initWithTitle:@"Remove item?"
                                        message:@"The quantity for this item is 0 - would you like to remove it from the cart?"
                                       delegate:self
                              cancelButtonTitle:@"Yes" //index = 0
                               otherButtonTitles:@"No", nil];
            [removeItem setTag:REMOVE_ITEM_ALERT_TAG];
            [removeItem show];
        }
        
        selectedItem = [[Order current] getOrderItem:selectedItem.locationItem.menuItemId.objectId];
        
        NSNumber *totalItemCost = [NSNumber numberWithFloat:[selectedItem calculateCost]];
        NSNumber *itemUnitCost = [NSNumber numberWithFloat:selectedItem.locationItem.costInCents / 100.0];
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
    if (0 == buttonIndex && alertView.tag == REMOVE_ITEM_ALERT_TAG) { //remove from cart
        [currentOrder removeOrderItem:selectedItem];
        [orderSummary reloadData];
    } else if(alertView.tag == COUPON_ALERT_TAG && 0 == buttonIndex){
        //send coupon code to server
        
        [SVProgressHUD showWithStatus:@"Validating code."];
        
        Order *order = [Order current];
        order.couponCode = [alertView textFieldAtIndex:0].text;
        order.locationId = [[[PFUser currentUser] valueForKey:@"locationId"] objectId];
        order.userId = [[PFUser currentUser] objectId];
        
        NSDictionary *o = [order toDictionary];
        
        [[ParseClient current] POST:Coupon parameters:o
                          success:^(NSURLSessionDataTask *operation, id responseObject) {
                              NSError *error;
                              couponEntered = (CouponValidation*)[[CouponValidateResult alloc] initWithDictionary:responseObject error:&error].result;
                              if(couponEntered.valid){
                                  order.couponValidateResult = couponEntered;
                                  [self updateOrderCost];
                                  [SVProgressHUD dismiss];
                              } else{
                                  [SVProgressHUD dismiss];
                                  [[[UIAlertView alloc] initWithTitle:@"Coupon Invalid!"
                                                              message:couponEntered.message
                                                             delegate:nil
                                                    cancelButtonTitle:@"Okay"
                                                    otherButtonTitles:nil] show];
                              }
                          }
                          failure:^(NSURLSessionDataTask *task, NSError *error) {
                              [SVProgressHUD dismiss];
                              NSLog(@"error checking code : %@",error.description);
                              order.couponCode = @"";
                          }];
    } else if(alertView.tag == COUPON_REMOVE_TAG && 0 == buttonIndex){
        [Order current].couponValidateResult = NULL;
        [Order current].couponCode = @"";
        [self updateOrderCost];
    }
}

- (void)updateOrderCost{
    
    if([Order current].couponValidateResult != NULL && [Order current].couponValidateResult.valid)
    {
        float cost = [currentOrder calculateTotalOrderCost];
        cost -= [Order current].couponValidateResult.amount;
        if(cost < 0){
            cost = 0.00;
        }
        NSNumber *totalOrderCost = [NSNumber numberWithFloat:cost];
        orderTotal.text = [formatter stringFromNumber:totalOrderCost];
        
        NSNumber *couponAmount = [NSNumber numberWithInt:(couponEntered.amount / 100)];
        NSString *couponString = [NSString stringWithFormat:@"after %@ coupon!",[formatter stringFromNumber:couponAmount]];
        
        NSMutableAttributedString *couponBtnString = [[NSMutableAttributedString alloc] initWithString:couponString];
        
        [couponBtnString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [couponBtnString length])];
        [couponBtnString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, [couponBtnString length])];
        
        [coupon setAttributedTitle:couponBtnString forState:UIControlStateNormal];
        [coupon setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    } else {
        NSMutableAttributedString *couponBtnString = [[NSMutableAttributedString alloc] initWithString:@"Apply Coupon"];
        
        [couponBtnString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [couponBtnString length])];
        [couponBtnString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [couponBtnString length])];
        
        [coupon setAttributedTitle:couponBtnString forState:UIControlStateNormal];
        [coupon setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
        NSNumber *totalOrderCost = [NSNumber numberWithFloat:[currentOrder calculateTotalOrderCost]];
        orderTotal.text = [formatter stringFromNumber:totalOrderCost];
    }
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
    
    if(![order.couponCode isEqual:@""] && couponEntered.valid){
        order.totalInCents -= couponEntered.amount;
        if(order.totalInCents < 0)
            order.totalInCents = 0;
    }
    
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
