//
//  CloudinaryClient.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 1/8/14.
//
//

#import "AFHTTPSessionManager.h"

@interface CloudinaryClient : AFHTTPSessionManager

+ (CloudinaryClient*)current;

@end
