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
@synthesize locationId;
@synthesize items;
@synthesize orderItems;

-(id)init
{
    if(!(self = [super init]))
        return nil;
    
    NSLog(@"Current order being initialized.");
    items = [[NSMutableDictionary alloc]initWithCapacity:100];
    
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

-(NSMutableArray<OrderItem>*)convertToOrderItemArray
{
    orderItems = (NSMutableArray<OrderItem>*)[[NSMutableArray alloc] initWithCapacity:[self getNumberUniqueItems]];
    int count = 0;
    
    for (id key in items) {
        OrderItem* item = [items objectForKey:key];
        if(item.quantity > 0)
        {
            orderItems[count] = item;
            count++;
        }
    }
    
    return orderItems;
}

-(OrderItem*)getOrderItem:(NSString*)itemId
{
    return [items objectForKey:itemId];
}

-(int)getNumberUniqueItems
{
    int uniqueCount = 0;
    for (id key in items) {
        OrderItem* item = [items objectForKey:key];
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
    NSEnumerator *allItems = items.keyEnumerator;
    while (key = [allItems nextObject]) {
        totalCount += ((OrderItem*)[items objectForKey:key]).quantity;
    }
    return totalCount;
}

/** Method to retrieve the quantity in the current order for a specific item.
    Returns -1 if the item hasn't been added to the order yet.
 */
-(int)getSpecificItemCount:(NSString*)itemId
{
    if(nil == [items valueForKey:itemId])
        return -1;
    
    return ((OrderItem*)[items valueForKey:itemId]).quantity;
}

-(void)clearEntireOrder
{
    [items removeAllObjects];
}

-(BOOL)setOrderItemQuantity:(OrderItem*)item withQuantity:(int)quantity
{
    @synchronized(orderItems)
    {
        if(items.count > 100 || (items.count + item.quantity) > 100)
        {
            NSLog(@"Order limit exceeded.");
            return NO;
        }
        else
        {
            item.quantity = quantity;
            [items setValue:item forKey:item.menuItem.uid];
            
            NSLog(@"Added item : %@ to order, now has count of : %d.", item.menuItem.name, [self getSpecificItemCount:item.menuItem.uid]);
            NSLog(@"Current order : %@", items);
            
            return YES;
        }
    }
}

-(double)calculateTotalOrderCost
{
    int totalCost = 0;
    for (id key in items) {
        OrderItem* item = [items objectForKey:key];
        totalCost += [item calculateCost];
    }
    return totalCost;
}

-(double)calculateDoRyteDonation
{
    return [self calculateTotalOrderCost] * .05;
}

@end
