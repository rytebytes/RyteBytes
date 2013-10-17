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

@implementation OrderSummaryViewController

@synthesize orderSummary;
@synthesize orderTotal;
@synthesize doRyteTotal;

Order *currentOrder;
NSMutableArray *orderArray;
int orderTotalCost = 0;

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
    
    orderTotal.text = [NSString stringWithFormat:@"$%d", orderTotalCost];
    doRyteTotal.text = [NSString stringWithFormat:@"$%fd", orderTotalCost * .1];
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
    cell.itemName.text = item.menuItem.name;
    cell.quantity.text = [NSString stringWithFormat:@"%d", item.orderCount];
    
    switch (item.menuItem.type) {
        case Whole:
            cell.unitCost.text = @"$10";
            cell.totalCost.text = [NSString stringWithFormat:@"$%d",(item.orderCount * 10)];
            orderTotalCost += (item.orderCount * 10);
            break;
        case Protein: case Starch: case Vegetable:
            cell.unitCost.text = @"$2";
            cell.totalCost.text = [NSString stringWithFormat:@"$%d",(item.orderCount * 2)];
            orderTotalCost += (item.orderCount * 2);
            break;
    }
    
    return cell;
}

- (IBAction)placeOrder:(id)sender {
    
    NSMutableDictionary *items = [[NSMutableDictionary alloc] init];
    for(int count = 0; count < orderArray.count; count++){
        [items setValue:[NSString stringWithFormat:@"%d", ((OrderItem*)orderArray[count]).orderCount] forKey:((OrderItem*)orderArray[count]).menuItem.uniqueId];
    }
    
    NSMutableDictionary *order = [[NSMutableDictionary alloc] init];
    
    [order setValue:[PFUser currentUser].objectId forKey:ORDER_USER_ID];
    [order setValue:@"1" forKey:ORDER_PICKUP_ID];
    [order setValue:@"2" forKey:ORDER_COUPON_ID];
    [order setObject:items forKey:ORDER_ITEMS];
    
    NSLog(@"send order for item (%@) with id : %@", ((OrderItem*)orderArray[0]).menuItem.name, ((OrderItem*)orderArray[0]).menuItem.uniqueId);
    
    [[ParseClient current] postPath:PlaceOrder parameters:order
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"placed order succesfully, message : %@", responseObject);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"placed order failing, message : %@", [error localizedDescription]);
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
