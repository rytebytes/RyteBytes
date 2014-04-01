//
//  OrderItem.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 9/10/13.
//
//

#import <Foundation/Foundation.h>
#import "LocationItem.h"

@protocol OrderItem
@end

@interface OrderItem : JSONModel

@property (nonatomic,strong) LocationItem<Ignore>* locationItem;
@property int quantity;

-(id)initWithLocationItem:(LocationItem*)item;
-(id)initWithLocationItem:(LocationItem*)item withQuantity:(int)q;

-(float)calculateCost;

@end
