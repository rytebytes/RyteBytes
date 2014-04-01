//
//  ParseClient.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 8/26/13.
//
//

#import "AFHTTPSessionManager.h"

@interface ParseClient : AFHTTPSessionManager

+(ParseClient*) current;

extern NSString * const CreateUser;
extern NSString * const RetrieveMenu;
extern NSString * const PlaceOrder;
extern NSString * const Locations;
extern NSString * const GetLocation;
extern NSString * const UserInfo;
extern NSString * const UpdateUser;
extern NSString * const Content;
extern NSString * const Coupon;

@end
