//
//  ParseClient.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 8/26/13.
//
//

#import "ParseClient.h"
#import "AFNetworking.h"

@implementation ParseClient

static NSString * const ParseUrl = @"https://api.parse.com/%@/functions";
static NSString * const ParseVer = @"1";

NSString * const CreateUser = @"createuser";

- (id)initWithBaseUrl:(NSString*)baseUrl withVersion:(NSString*)version
{
    NSString *fullBaseUrl = [NSString stringWithFormat:baseUrl, version];
    
    NSURL *base = [NSURL URLWithString:fullBaseUrl];
    NSLog(@"Creating parse http client with base url of : %@", base);
    
    self = [super initWithBaseURL:base];
    
    if(!self){
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setDefaultHeader:@"X-Parse-Application-Id" value:@"zaZmkcjbGLCrEHagb8uJPt5TKyiFgCg9WffA6c6M"];
    [self setDefaultHeader:@"X-Parse-REST-API-Key" value:@"ZjCVp64qsDxYWw6PktZgc5PFZLdLmRuHe9oOF3q9"];
    [self setParameterEncoding:AFJSONParameterEncoding];
    
    return self;
}

+ (ParseClient*)current
{
    static ParseClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] initWithBaseUrl:ParseUrl withVersion:ParseVer];
    });
    return sharedClient;
}
@end
