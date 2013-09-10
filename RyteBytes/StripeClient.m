//
//  StripeClient.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 8/10/13.
//
//

#import "StripeClient.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

@implementation StripeClient

static NSString * const StripeUrl = @"https://api.stripe.com/%@/";
static NSString * const StripeVer = @"v1";

NSString * const CreateCustomerUrl = @"customers";

- (id)initWithBaseUrl:(NSString*)baseUrl withVersion:(NSString*)version
{
    NSString *fullBaseUrl = [NSString stringWithFormat:baseUrl, version];
    
    NSURL *base = [NSURL URLWithString:fullBaseUrl];
    NSLog(@"Creating stripe http client with base url of : %@", base);
    
    self = [super initWithBaseURL:base];
    
    if(!self){
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setAuthorizationHeaderWithUsername:@"pk_test_pDS0kwh6BQ2pLv7sadAQcrPr" password:@""];
    [self setParameterEncoding:AFJSONParameterEncoding];
    
    return self;
}

+ (StripeClient*)current
{
    static StripeClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] initWithBaseUrl:StripeUrl withVersion:StripeVer];
    });
    return sharedClient;
}
@end