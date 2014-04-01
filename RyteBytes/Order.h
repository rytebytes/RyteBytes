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

@protocol OrderUpdatedWithNewMenu <NSObject>
-(void)orderUpdatedWithNewMenu;
@end


@interface Order : JSONModel

@property (strong,nonatomic) NSString *userId;
@property (strong,nonatomic) NSString *locationId;
@property (strong,nonatomic) NSString *couponCode;
@property (strong,nonatomic) NSMutableDictionary<OrderItem,Optional> *orderItemDictionary;
@property (nonatomic) int totalInCents;
@property (strong,nonatomic) Menu<Ignore> *menu;
@property (nonatomic,weak) id<OrderUpdatedWithNewMenu,Ignore> delegate;

+ (Order*)current;

-(int)getTotalItemCount;
-(int)getSpecificItemCount:(NSString*)itemId;
-(int)getNumberUniqueItems;
-(NSMutableArray<OrderItem>*)convertToOrderItemArray;

-(OrderItem*)getOrderItem:(NSString*)itemId;
-(BOOL)setLocationItem:(LocationItem*)locationItem withQuantity:(int)quantity;
-(BOOL)setOrderItem:(OrderItem*)item;
-(void)removeOrderItem:(OrderItem*)item;
-(NSString*)checkForOutOfStockItems;

-(void)clearEntireOrder;

-(float)calculateTotalOrderCost;
-(int)calculateTotalOrderCostInCents;
-(double)calculateDoRyteDonation;

-(NSString*)serializeToString;

@end

