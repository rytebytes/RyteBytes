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
#import "OrderItem.h"

@interface Order : NSObject

+ (Order*)current;

-(int)getTotalItemCount;
-(int)getSpecificItemCount:(NSString*)itemId;
-(int)getNumberUniqueItems;
-(NSMutableArray*)convertToOrderItemArray;
-(OrderItem*)getOrderItem:(NSString*)itemId;

-(void)clearEntireOrder;
-(BOOL)setOrderItemQuantity:(OrderItem*)item withQuantity:(int)quantity;

@end

