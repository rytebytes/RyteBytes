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
@synthesize orderItemDictionary;

-(id)init
{
    if(!(self = [super init]))
        return nil;
    
    NSLog(@"Current order being initialized.");
    orderItemDictionary = (NSMutableDictionary<OrderItem,Optional>*)[[NSMutableDictionary alloc]initWithCapacity:100];
    
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

-(NSMutableArray<OrderItem>*)convertToOrderItemArray
{
    NSMutableArray<OrderItem> *orderItemArray = (NSMutableArray<OrderItem,Optional>*)[[NSMutableArray alloc] initWithCapacity:[self getNumberUniqueItems]];
    int count = 0;
    
    for (id key in orderItemDictionary) {
        OrderItem* item = [orderItemDictionary objectForKey:key];
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
    return [orderItemDictionary objectForKey:itemId];
}

-(int)getNumberUniqueItems
{
    int uniqueCount = 0;
    for (id key in orderItemDictionary) {
        OrderItem* item = [orderItemDictionary objectForKey:key];
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
    NSEnumerator *allItems = orderItemDictionary.keyEnumerator;
    while (key = [allItems nextObject]) {
        totalCount += ((OrderItem*)[orderItemDictionary objectForKey:key]).quantity;
    }
    return totalCount;
}

/** Method to retrieve the quantity in the current order for a specific item.
    Returns -1 if the item hasn't been added to the order yet.
 */
-(int)getSpecificItemCount:(NSString*)itemId
{
    if(nil == [orderItemDictionary valueForKey:itemId])
        return 0;
    
    return ((OrderItem*)[orderItemDictionary valueForKey:itemId]).quantity;
}

-(void)clearEntireOrder
{
    [orderItemDictionary removeAllObjects];
}

-(BOOL)setOrderItem:(OrderItem*)item
{
    if([[Menu current] isQuantityAvailable:item.locationItem.objectId withQuantity:item.quantity]){
        [orderItemDictionary setValue:item forKey:item.locationItem.menuItemId.objectId];
        return YES;
    }
    return NO;
}

-(BOOL)setLocationItem:(LocationItem*)locationItem withQuantity:(int)quantity;
{
    if(orderItemDictionary.count > 100 || (orderItemDictionary.count + quantity) > 100)
    {
        NSLog(@"Order limit exceeded.");
        return NO;
    }
    
    if([[Menu current] isQuantityAvailable:locationItem.menuItemId.objectId withQuantity:quantity]){
        //key : objectId
        //value : orderItem (so we can access all info on the order summary screen
        OrderItem *item = [[OrderItem alloc] initWithLocationItem:locationItem withQuantity:quantity];
        [orderItemDictionary setValue:item forKey:item.locationItem.menuItemId.objectId];
        
        NSLog(@"Added item : %@ to order, now has count of : %d.", locationItem.menuItemId.name, [self getSpecificItemCount:item.locationItem.menuItemId.objectId]);
        
        return YES;
    }
    return NO;
}

-(NSString*)checkForOutOfStockItems
{
    Menu *menu = [Menu current];
    NSMutableArray *keysToRemove = [[NSMutableArray alloc] initWithCapacity:orderItemDictionary.count];
    NSString* unavailableItems = @"";
    for (id key in orderItemDictionary) {
        OrderItem* item = [orderItemDictionary objectForKey:key];
        if(![menu isQuantityAvailable:item.locationItem.menuItemId.objectId withQuantity:item.quantity]){
            [keysToRemove addObject:item.locationItem.objectId];
            if ([unavailableItems isEqualToString:@""]) {
                unavailableItems = item.locationItem.menuItemId.name;
            } else {
                unavailableItems = [NSString stringWithFormat:@"%@, %@",unavailableItems,item.locationItem.menuItemId.name];
            }
        }
    }
    
    for (id key in keysToRemove) {
        [orderItemDictionary removeObjectForKey:key];
    }
    
    return unavailableItems;
}

-(void)removeOrderItem:(OrderItem *)item
{
    [orderItemDictionary removeObjectForKey:item.locationItem.menuItemId.objectId];
}

-(int)calculateTotalOrderCostInCents
{
    return [self calculateTotalOrderCost] * 100;
}

-(float)calculateTotalOrderCost
{
    float totalCost = 0;
    for (id key in orderItemDictionary) {
        OrderItem* item = [orderItemDictionary objectForKey:key];
        totalCost += [item calculateCost];
    }
    return totalCost;
}

-(double)calculateDoRyteDonation
{
    return [self calculateTotalOrderCost] * .05;
}

-(NSString*)serializeToString
{
    [self.orderItemDictionary removeAllObjects];
    return [self toJSONString];
}

@end
