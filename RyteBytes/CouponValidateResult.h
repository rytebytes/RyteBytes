//
//  CouponValidateResult.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 3/29/14.
//
//

#import "JSONModel.h"
#import "CouponValidation.h"

@interface CouponValidateResult : JSONModel

@property (nonatomic,strong) CouponValidation *result;

@end
