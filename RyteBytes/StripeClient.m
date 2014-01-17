//
//  StripeClient.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 8/10/13.
//
//

#import "StripeClient.h"
#import "JSONResponseSerializerWithData.h"

@implementation StripeClient

static NSString * const StripeUrl = @"https://api.stripe.com/%@/";
static NSString * const StripeVer = @"v1";

NSString * const Customers = @"customers";
NSString * const ExistingCustomerFormat = @"customers/%@";

- (id)initWithBaseUrl:(NSString*)baseUrl withVersion:(NSString*)version
{
    NSString *fullBaseUrl = [NSString stringWithFormat:baseUrl, version];
    
    NSURL *base = [NSURL URLWithString:fullBaseUrl];
    NSLog(@"Creating stripe http client with base url of : %@", base);
    
    self = [super initWithBaseURL:base];
    
    if(!self){
        return nil;
    }
    AFHTTPRequestSerializer *requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    JSONResponseSerializerWithData *jsonResponse = [[JSONResponseSerializerWithData alloc]init];

    self.requestSerializer = requestSerializer;
    self.responseSerializer = jsonResponse;
#ifdef DEBUG
    NSLog(@"use test key");
    [self.requestSerializer setAuthorizationHeaderFieldWithUsername:@"sk_test_0eORjVUmVNJxwTHqMLLCogZr" password:@""];
#else
    NSLog(@"use live key");
    [self.requestSerializer setAuthorizationHeaderFieldWithUsername:@"pk_live_RjYLDJ0wr0c1ob09hUZtpnCv" password:@""];
#endif
    
    
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