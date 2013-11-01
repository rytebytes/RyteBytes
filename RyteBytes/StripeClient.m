//
//  StripeClient.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 8/10/13.
//
//

#import "StripeClient.h"

@implementation StripeClient

static NSString * const StripeUrl = @"https://api.stripe.com/%@/";
static NSString * const StripeVer = @"v1";

NSString * const CreateCustomer = @"customers";

- (id)initWithBaseUrl:(NSString*)baseUrl withVersion:(NSString*)version
{
    NSString *fullBaseUrl = [NSString stringWithFormat:baseUrl, version];
    
    NSURL *base = [NSURL URLWithString:fullBaseUrl];
    NSLog(@"Creating stripe http client with base url of : %@", base);
    
    self = [super initWithBaseURL:base];
    
    if(!self){
        return nil;
    }
    AFJSONRequestSerializer *jsonRequest = [[AFJSONRequestSerializer alloc] init];
    AFJSONResponseSerializer *jsonResponse = [[AFJSONResponseSerializer alloc]init];
    
    self.requestSerializer = jsonRequest;
    self.responseSerializer = jsonResponse;
    
    [self.requestSerializer setValue:@"zaZmkcjbGLCrEHagb8uJPt5TKyiFgCg9WffA6c6M" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [self.requestSerializer setAuthorizationHeaderFieldWithUsername:@"sk_test_0eORjVUmVNJxwTHqMLLCogZr" password:@""];
    
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