//
//  StripeErrorResponse.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 11/22/13.
//
//

#import "JSONModel.h"
#import "StripeError.h"

@interface StripeErrorResponse : JSONModel
@property (nonatomic,strong) StripeError *error;
@end
