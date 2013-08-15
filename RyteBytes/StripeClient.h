//
//  StripeClient.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 8/10/13.
//
//

#import <AFNetworking.h>
#import "AFJSONRequestOperation.h"

@interface StripeClient : AFHTTPClient

extern NSString * const CreateCustomerUrl;

+ (StripeClient*)current;

@end
