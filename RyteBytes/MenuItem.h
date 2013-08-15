//
//  MenuItem.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 7/20/13.
//
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "NutritionInformation.h"

@interface MenuItem : NSObject

@property MenuItemTypes type;
@property NSString *name;
@property NutritionInformation *nutritionInfo;
@property double price;

-(id)initWithName:(NSString*)n withPrice:(double)p withType:(MenuItemTypes)t withNutritionInfo:(NutritionInformation*)info;

@end
