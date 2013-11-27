//
//  StripeClient.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 8/10/13.
//
//

#import <AFNetworking.h>
#import "StripeCustomer.h"
#import "AFHTTPSessionManager.h"

@interface StripeClient : AFHTTPSessionManager

extern NSString * const Customers;
extern NSString * const GetCustomerFormat;

+ (StripeClient*)current;

@end
