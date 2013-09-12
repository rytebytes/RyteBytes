//
//  Order.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 7/20/13.
//
//

#import "Order.h"
#import "OrderItem.h"

@implementation Order

NSMutableDictionary *menuItemsOrdered;


-(id)initEmptyOrder
{
    if(!(self = [super init]))
        return nil;
    
    NSLog(@"Current order being initialized.");
    menuItemsOrdered = [[NSMutableDictionary alloc]initWithCapacity:100];
    
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
    
    for (id key in menuItemsOrdered) {
        MenuItem *menuItem = [[MenuItem alloc] init];
        menuItem.name = key;
        NSInteger itemOrderedCount = [[menuItemsOrdered valueForKey:key] integerValue];
        
        OrderItem *orderItem = [[OrderItem alloc] initWithMenuItem:menuItem withQuantity:itemOrderedCount];
        orderItemArray[count] = orderItem;
        count++;
    }
    
    return orderItemArray;
}


-(int)getNumberUniqueItems
{
    return menuItemsOrdered.count;
}

-(int)getTotalItemCount
{
    int totalCount = 0;
    NSString *key;
    NSEnumerator *allItems = menuItemsOrdered.keyEnumerator;
    while (key = [allItems nextObject]) {
        totalCount += [[menuItemsOrdered objectForKey:key] intValue];
    }
    return totalCount;
}

-(int)getSpecificMenuItemCount:(NSString*)menuItemName
{
    return [[menuItemsOrdered valueForKey:menuItemName] integerValue];
}

-(void)clearEntireOrder
{
    [menuItemsOrdered removeAllObjects];
}

-(BOOL)setMenuItemQuantity:(MenuItem*)item withQuantity:(NSInteger)quantity
{
    @synchronized(menuItemsOrdered)
    {
        if(menuItemsOrdered.count > 100 || (menuItemsOrdered.count + quantity) > 100)
        {
            NSLog(@"Order limit exceeded.");
            return NO;
        }
        else
        {
            if(0 == quantity)
            {
                [menuItemsOrdered removeObjectForKey:item.name];
            }
            else
            {
                [menuItemsOrdered setValue:[NSString stringWithFormat:@"%d",quantity] forKey:item.name];
            }
            
            NSLog(@"Added item : %@ to order, now has count of : %d.", item.name, [self getSpecificMenuItemCount:item.name]);
            NSLog(@"Current order : %@", menuItemsOrdered);
            
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
