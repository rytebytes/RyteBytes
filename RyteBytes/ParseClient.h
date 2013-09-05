//
//  ParseClient.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 8/26/13.
//
//

#import "AFHTTPClient.h"

@interface ParseClient : AFHTTPClient

+(ParseClient*) current;

extern NSString * const CreateUser;
extern NSString * const RetrieveMenu;

@end
