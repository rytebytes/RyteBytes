//
//  Order.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 7/20/13.
//
//

#import "Order.h"
#import "OrderItem.h"

/** This class manages the current order for the user.  When a user selects a menu item and increases or decreases the quantity desired,
    this class will handle reflecting that on the order summary screen.  This class keeps a dictionary of OrderItem objects that reflects the
    current state of the order.  The key in the dictionary is the unique id of the item and the value is the OrderItem object 
    (which contains the MenuItem and the current quantity).  When a quantity reaches 0, it is removed from the dictionary.
 */
@implementation Order

@synthesize userId;
@synthesize pickupId;
@synthesize orderItems;
@synthesize couponId;

-(id)init
{
    if(!(self = [super init]))
        return nil;
    
    NSLog(@"Current order being initialized.");
    orderItems = [[NSMutableDictionary alloc]initWithCapacity:100];
    
    return self;
}

+(Order*)current
{
    static Order *currentOrder;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentOrder = [[self alloc] init];
    });
    return currentOrder;
}

-(void)setupOrderWithMenu:(NSArray*)menu
{
    for (MenuItem* item in menu) {
        [self setOrderItemQuantity:[[OrderItem alloc] initWithMenuItem:item] withQuantity:0];
    }
}

-(NSMutableArray*)convertToOrderItemArray
{
    NSMutableArray *orderItemArray = [[NSMutableArray alloc] initWithCapacity:[self getNumberUniqueItems]];
    int count = 0;
    
    for (id key in orderItems) {
        OrderItem* item = [orderItems objectForKey:key];
        if(item.quantity > 0)
        {
            orderItemArray[count] = item;
            count++;
        }
    }
    
    return orderItemArray;
}

-(OrderItem*)getOrderItem:(NSString*)itemId
{
    return [orderItems objectForKey:itemId];
}

-(int)getNumberUniqueItems
{
    int uniqueCount = 0;
    for (id key in orderItems) {
        OrderItem* item = [orderItems objectForKey:key];
        if(item.quantity > 0)
        {
            uniqueCount++;
        }
    }
    return uniqueCount;
}

-(int)getTotalItemCount
{
    int totalCount = 0;
    NSString *key;
    NSEnumerator *allItems = orderItems.keyEnumerator;
    while (key = [allItems nextObject]) {
        totalCount += ((OrderItem*)[orderItems objectForKey:key]).quantity;
    }
    return totalCount;
}

/** Method to retrieve the quantity in the current order for a specific item.
    Returns -1 if the item hasn't been added to the order yet.
 */
-(int)getSpecificItemCount:(NSString*)itemId
{
    if(nil == [orderItems valueForKey:itemId])
        return -1;
    
    return ((OrderItem*)[orderItems valueForKey:itemId]).quantity;
}

-(void)clearEntireOrder
{
    [orderItems removeAllObjects];
}

-(BOOL)setOrderItemQuantity:(OrderItem*)item withQuantity:(int)quantity
{
    @synchronized(orderItems)
    {
        if(orderItems.count > 100 || (orderItems.count + item.quantity) > 100)
        {
            NSLog(@"Order limit exceeded.");
            return NO;
        }
        else
        {
            item.quantity = quantity;
            [orderItems setValue:item forKey:item.menuItem.uid];
            
            NSLog(@"Added item : %@ to order, now has count of : %d.", item.menuItem.name, [self getSpecificItemCount:item.menuItem.uid]);
            NSLog(@"Current order : %@", orderItems);
            
            return YES;
        }
    }
}

-(double)calculateTotalOrderCost
{
    int totalCost = 0;
    for (id key in orderItems) {
        OrderItem* item = [orderItems objectForKey:key];
        totalCost += [item calculateCost];
    }
    return totalCost;
}

-(double)calculateDoRyteDonation
{
    return [self calculateTotalOrderCost] * .05;
}

@end
