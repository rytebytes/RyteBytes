//
//  Order.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 7/20/13.
//
//

#import "Order.h"

@implementation Order

NSMutableDictionary *separateItems;
NSMutableDictionary *dishes;
static Order *currentOrder;
static int orderCount;
static BOOL initialized = NO;

+ (void)initialize
{
    NSLog(@"Initialize called in order.");
    if(!initialized)
    {
        initialized = YES;
        currentOrder = [[Order alloc] init];
        separateItems = [[NSMutableDictionary alloc]initWithCapacity:100];
        dishes = [[NSMutableDictionary alloc]initWithCapacity:100];
        orderCount = 0;
    }
}

+ (Order*)current
{
    return currentOrder;
}

- (int)getNumberUniqueDishes
{
    return dishes.count;
}

- (int)getTotalNumberDishes
{
    int totalCount = 0;
    NSString *key;
    NSEnumerator *allDishes = dishes.keyEnumerator;
    while (key = [allDishes nextObject]) {
        totalCount += [[dishes objectForKey:key] intValue];
    }
    
    return totalCount;
}

- (int)getCurrentItemCount;
{
    return separateItems.count + [self getTotalNumberDishes];
}

- (BOOL)addDishToOrder:(Dish*)dish
{
    @synchronized(dishes)
    {
        if(dishes.count > 100)
        {
            NSLog(@"Order limit exceeded.");
            return NO;
        }
        else
        {
            if(nil == [dishes objectForKey:dish.name]) //dish hasn't been added to order yet
            {
                [dishes setObject:[NSNumber numberWithInt:1] forKey:dish.name];
            }
            else //dish has been added, increment number
            {
                NSNumber *nsCount = [dishes objectForKey:dish.name];
                int count = [nsCount intValue] + 1;
                [dishes setObject:[NSNumber numberWithInt:(count)] forKey:dish.name];
            }
            orderCount++;
            return YES;
        }
    }
}


- (BOOL)addMenuItemToOrder:(MenuItem*)item
{
    @synchronized(separateItems)
    {
        if(separateItems.count > 100)
        {
            NSLog(@"Order limit exceeded.");
            return NO;
        }
        else
        {
            orderCount++;
            return YES;
        }
    }
}

- (void)removeMenuItemFromOrder:(MenuItem*)item
{
    @synchronized(separateItems)
    {
        if(separateItems.count != 0)
        {
            
        }
    }
}

@end
