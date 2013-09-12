//
//  OrderItem.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 9/10/13.
//
//

#import "OrderItem.h"
#import "Order.h"

@implementation OrderItem
@synthesize menuItem;
@synthesize orderCount;

-(id)initWithMenuItem:(MenuItem*)item withQuantity:(int)quantity
{
    if(!(self = [super init]))
        return nil;
    
    self.menuItem = item;
    self.orderCount = quantity;
    
    return self;
}

@end
