//
//  Constants.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 7/20/13.
//
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

extern const int TAG_UI_CREATEACCOUNT_EMAIL;
extern const int TAG_UI_CREATEACCOUNT_PASSWORD;
extern const int TAG_UI_CREATEACCOUNT_CONFIRM_PASSWORD;

extern const int TAG_UI_LOGIN_EMAIL;
extern const int TAG_UI_LOGIN_PASSWORD;

extern NSString * const CLOUDINARY_IMAGE_URL;
extern NSString * const CLOUDINARY_IMAGE_W_H_URL;

typedef enum itemtypes
{
    Protein = 0,
    Starch = 1,
    Vegetable = 2,
    Whole = 3 //dishes that are packaged together (i.e. pasta, soup, etc.)
    
} MenuItemTypes;

//Custom Fields For Parse Objects
extern NSString * const STRIPE_ID;
extern NSString * const USER_LOCATION;

//Keys for order JSON
extern NSString * const ORDER_USER_ID;
extern NSString * const ORDER_LOCATION_ID;
extern NSString * const ORDER_ITEMS;
extern NSString * const ORDER_COUPON_ID;

@end
