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

//a dictionary of OrderItems
NSMutableDictionary *orderItems;

-(id)initEmptyOrder
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
        currentOrder = [[self alloc] initEmptyOrder];
    });
    return currentOrder;
}

-(NSMutableArray*)convertToOrderItemArray
{
    NSMutableArray *orderItemArray = [[NSMutableArray alloc] initWithCapacity:[self getNumberUniqueItems]];
    int count = 0;
    
    for (id key in orderItems) {
        orderItemArray[count] = [orderItems objectForKey:key];
        count++;
    }
    
    return orderItemArray;
}

-(OrderItem*)getOrderItem:(NSString*)itemId
{
    return [orderItems objectForKey:itemId];
}

-(int)getNumberUniqueItems
{
    return orderItems.count;
}

-(int)getTotalItemCount
{
    int totalCount = 0;
    NSString *key;
    NSEnumerator *allItems = orderItems.keyEnumerator;
    while (key = [allItems nextObject]) {
        totalCount += ((OrderItem*)[orderItems objectForKey:key]).orderCount;
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
    
    return ((OrderItem*)[orderItems valueForKey:itemId]).orderCount;
}

-(void)clearEntireOrder
{
    [orderItems removeAllObjects];
}

-(BOOL)setOrderItemQuantity:(OrderItem*)item withQuantity:(int)quantity
{
    @synchronized(orderItems)
    {
        if(orderItems.count > 100 || (orderItems.count + item.orderCount) > 100)
        {
            NSLog(@"Order limit exceeded.");
            return NO;
        }
        else
        {
            if(0 == quantity)
            {
                [orderItems removeObjectForKey:item.menuItem.uniqueId];
            }
            else
            {
                item.orderCount = quantity;
                [orderItems setValue:item forKey:item.menuItem.uniqueId];
            }
            
            NSLog(@"Added item : %@ to order, now has count of : %d.", item.menuItem.name, [self getSpecificItemCount:item.menuItem.uniqueId]);
            NSLog(@"Current order : %@", orderItems);
            
            return YES;
        }
    }
}

//- (void)removeMenuItemFromOrder:(MenuItem*)item
//{
//    @synchronized(menuItemsOrdered)
//    {
//        if(menuItemsOrdered.count != 0)
//        {
//            if(nil != [menuItemsOrdered valueForKey:item.name])
//            {
//                NSInteger menuItemOrderCount = [[menuItemsOrdered valueForKey:item.name] integerValue];
//                menuItemOrderCount--;
//                if(menuItemOrderCount == 0)
//                    [menuItemsOrdered removeObjectForKey:item.name];
//                else
//                    [menuItemsOrdered setValue:[NSString stringWithFormat:@"%d",menuItemOrderCount] forKey:item.name];
//            }
//        }
//    }
//}

@end
