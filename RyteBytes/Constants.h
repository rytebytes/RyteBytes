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

typedef enum itemtypes
{
    Protein = 0,
    Starch = 1,
    Vegetable = 2,
    Whole = 3 //dishes that are packaged together (i.e. pasta, soup, etc.)
    
} MenuItemTypes;

//Custom Fields For Parse Objects
extern NSString * const STRIPE_ID;

//Web Service URLs

@end
