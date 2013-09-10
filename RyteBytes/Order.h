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

+ (Order*)current;

-(int)getTotalItemCount;
-(int)getSpecificMenuItemCount:(NSString*)menuItemName;
-(int)getNumberUniqueItems;

-(void)clearEntireOrder;
-(BOOL)setMenuItemQuantity:(MenuItem*)item withQuantity:(NSInteger)quantity;

@end

