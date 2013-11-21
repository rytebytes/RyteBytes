//
//  OrderItem.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 9/10/13.
//
//

#import <Foundation/Foundation.h>
#import "MenuItem.h"

@interface OrderItem : NSObject

@property (nonatomic,strong) MenuItem* menuItem;
@property (nonatomic) NSInteger quantity;

-(id)initWithMenuItem:(MenuItem*)item;
-(id)initWithMenuItem:(MenuItem*)item withQuantity:(int)q;

-(double)calculateCost;

@end
