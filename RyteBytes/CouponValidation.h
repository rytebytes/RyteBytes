//
//  CouponValidation.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 3/29/14.
//
//

#import "JSONModel.h"

@interface CouponValidation : JSONModel

@property (nonatomic) BOOL valid;
@property (nonatomic,strong) NSString *message;
@property (nonatomic) int amount;

@end
