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

@interface Order : JSONModel

@property (strong,nonatomic) NSString *userId;
@property (strong,nonatomic) NSString *locationId;
@property (strong,nonatomic) NSMutableArray<OrderItem> *orderItems;
@property (strong,nonatomic) NSMutableDictionary<Ignore> *items;
@property (strong,nonatomic) NSNumber *totalInCents;

+ (Order*)current;

-(int)getTotalItemCount;
-(int)getSpecificItemCount:(NSString*)itemId;
-(int)getNumberUniqueItems;
-(NSMutableArray<OrderItem>*)convertToOrderItemArray;

-(OrderItem*)getOrderItem:(NSString*)itemId;
-(BOOL)setOrderItemQuantity:(OrderItem*)item withQuantity:(int)quantity;

-(void)setupOrderWithMenu:(NSArray*)menu;
-(void)clearEntireOrder;

-(double)calculateTotalOrderCost;
-(double)calculateDoRyteDonation;

@end

