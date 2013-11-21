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
@synthesize quantity;

-(id)initWithMenuItem:(MenuItem *)item
{
    if(!(self = [super init]))
        return nil;
    
    self.menuItem = item;
    self.quantity = 0;
    
    return self;
}

-(id)initWithMenuItem:(MenuItem*)item withQuantity:(int)q
{
    if(!(self = [super init]))
        return nil;
    
    self.menuItem = item;
    self.quantity = q;
    
    return self;
}

-(double)calculateCost
{
    return menuItem.cost * quantity;
}

@end
