//
//  StripeCustomerResponse.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 1/20/14.
//
//

#import "JSONModel.h"
#import "StripeCustomer.h"

@interface StripeCustomerResponse : JSONModel
@property (nonatomic,strong) StripeCustomer *result;
@end
