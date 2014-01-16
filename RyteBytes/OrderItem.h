//
//  OrderItem.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 9/10/13.
//
//

#import <Foundation/Foundation.h>
#import "MenuItem.h"

@protocol OrderItem
@end

@interface OrderItem : JSONModel

@property (nonatomic,strong) MenuItem<Ignore>* menuItem;
@property int quantity;

-(id)initWithMenuItem:(MenuItem*)item;
-(id)initWithMenuItem:(MenuItem*)item withQuantity:(int)q;

-(float)calculateCost;

@end
