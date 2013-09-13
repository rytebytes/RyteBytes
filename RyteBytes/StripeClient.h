//
//  StripeClient.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 8/10/13.
//
//

#import <AFNetworking.h>
#import "AFJSONRequestOperation.h"
#import "StripeCustomer.h"

@interface StripeClient : AFHTTPClient

extern NSString * const CreateCustomer;

+ (StripeClient*)current;

@end
