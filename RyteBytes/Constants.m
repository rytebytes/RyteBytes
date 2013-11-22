//
//  Constants.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 7/20/13.
//
//

#import "Constants.h"

@implementation Constants

/* UI Tags */
const int TAG_UI_CREATEACCOUNT_EMAIL = 1001;
const int TAG_UI_CREATEACCOUNT_PASSWORD = 1002;
const int TAG_UI_CREATEACCOUNT_CONFIRM_PASSWORD = 1003;
const int TAG_UI_LOGIN_EMAIL = 1004;
const int TAG_UI_LOGIN_PASSWORD = 1005;


NSString * const STRIPE_ID = @"StripeId";
NSString * const USER_LOCATION_ID = @"LocationId";

NSString * const ORDER_USER_ID = @"userId";
NSString * const ORDER_LOCATION_ID = @"locationId";
NSString * const ORDER_COUPON_ID = @"couponId";
NSString * const ORDER_ITEMS = @"orderItems";

@end
