//
//  Utils.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 4/1/14.
//
//

#import "Utils.h"
#import "Constants.h"
#import <Parse/Parse.h>

@implementation Utils


+(BOOL)isCurrentUserAllowedToViewLocation:(NSString*)locationId
{
    if ([locationId isEqualToString:DEVELOPMENT_INVENTORY_LOCATION_ID]) { //dev inventory
        if([PFUser currentUser] &&
           ([[[PFUser currentUser] valueForKey:@"email"] isEqualToString:@"geoff@myrytebytes.com"] ||
            [[[PFUser currentUser] valueForKey:@"email"] isEqualToString:@"nick@myrytebytes.com"])){
               return true;
        }
        return false;
    }
    return true;
}

+(BOOL)isEmailAllowedToViewLocation:(NSString*)email withLocation:(NSString*)locationId
{
    if ([locationId isEqualToString:DEVELOPMENT_INVENTORY_LOCATION_ID]) { //dev inventory
        if([email isEqualToString:@"geoff@myrytebytes.com"] || [email isEqualToString:@"nick@myrytebytes.com"]){
               return true;
           }
        return false;
    }
    return true;
}

@end
