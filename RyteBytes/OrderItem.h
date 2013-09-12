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
@property (nonatomic) NSInteger orderCount;

-(id)initWithMenuItem:(MenuItem*)item withQuantity:(int)quantity;

@end
