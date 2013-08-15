//
//  Order.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 7/20/13.
//
//

#import <Foundation/Foundation.h>
#import "Dish.h"
#import "MenuItem.h"

@interface Order : NSObject

extern NSMutableDictionary *separateItems;
extern NSMutableDictionary *dishes;

+ (Order*)current;

- (int)getNumberUniqueDishes;
- (int)getCurrentItemCount;
- (BOOL)addDishToOrder:(Dish*)dish;
- (BOOL)addMenuItemToOrder:(MenuItem*)item;
- (void)removeMenuItemFromOrder:(MenuItem*)item;

@end

