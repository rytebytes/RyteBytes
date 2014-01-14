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
#import "Menu.h"


@interface Order : JSONModel

@property (strong,nonatomic) NSString *userId;
@property (strong,nonatomic) NSString *locationId;
@property (strong,nonatomic) NSMutableDictionary<OrderItem,Optional> *orderItemDictionary;
@property (nonatomic) int totalInCents;
@property (strong,nonatomic) Menu<Ignore> *menu;

+ (Order*)current;

-(int)getTotalItemCount;
-(int)getSpecificItemCount:(NSString*)itemId;
-(int)getNumberUniqueItems;
-(NSMutableArray<OrderItem>*)convertToOrderItemArray;

-(OrderItem*)getOrderItem:(NSString*)itemId;
-(BOOL)setMenuItem:(MenuItem*)menuItem withQuantity:(int)quantity;
-(BOOL)setOrderItem:(OrderItem*)item;
-(void)removeOrderItem:(OrderItem*)item;
-(NSString*)checkForOutOfStockItems;

-(void)clearEntireOrder;

-(double)calculateTotalOrderCost;
-(int)calculateTotalOrderCostInCents;
-(double)calculateDoRyteDonation;

-(NSString*)serializeToString;

@end

