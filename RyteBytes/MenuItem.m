//
//  MenuItem.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 7/20/13.
//
//

#import "MenuItem.h"

@implementation MenuItem

@synthesize nutritionInfo;
@synthesize price;
@synthesize name;
@synthesize type;

-(id)initWithName:(NSString*)n withPrice:(double)p withType:(MenuItemTypes)t withNutritionInfo:(NutritionInformation*)info
{
    if(!(self = [super init]))
        return nil;
    
    name = n;
    price = p;
    type = t;
    nutritionInfo = info;
    
    return self;
}

@end
