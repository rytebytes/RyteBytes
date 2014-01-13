//
//  CloudinaryClient.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 1/8/14.
//
//

#import "CloudinaryClient.h"

@implementation CloudinaryClient

static NSString * const CloudinaryUrl = @"http://res.cloudinary.com/rytebytes/image/upload";

- (id)initWithBaseUrl:(NSString*)baseUrl
{
    NSURL *base = [NSURL URLWithString:baseUrl];
    NSLog(@"Creating cloudinary http client with base url of : %@", base);
    
    self = [super initWithBaseURL:base];
    
    if(!self){
        return nil;
    }
    
    AFHTTPRequestSerializer *requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    AFImageResponseSerializer *imageResponse = [[AFImageResponseSerializer alloc]init];
    
    self.requestSerializer = requestSerializer;
    self.responseSerializer = imageResponse;
    
//    [self.requestSerializer setAuthorizationHeaderFieldWithUsername:@"sk_test_0eORjVUmVNJxwTHqMLLCogZr" password:@""];
    
    return self;
}

+ (CloudinaryClient*)current
{
    static CloudinaryClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] initWithBaseUrl:CloudinaryUrl];
    });
    return sharedClient;
}
@end
