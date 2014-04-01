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
@synthesize locationItem;
@synthesize quantity;

-(id)initWithLocationItem:(LocationItem *)item
{
    if(!(self = [super init]))
        return nil;
    
    self.locationItem = item;
    self.quantity = 0;
    
    return self;
}

-(id)initWithLocationItem:(LocationItem*)item withQuantity:(int)q
{
    if(!(self = [super init]))
        return nil;
    
    self.locationItem = item;
    self.quantity = q;
    
    return self;
}

-(float)calculateCost
{
    return (locationItem.costInCents / 100.0) * quantity;
}

@end
