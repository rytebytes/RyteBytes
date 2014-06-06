//
//  Utils.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 4/1/14.
//
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+(BOOL)isCurrentUserAllowedToViewLocation:(NSString*)locationId;
+(BOOL)isEmailAllowedToViewLocation:(NSString*)email withLocation:(NSString*)locationId;

@end
