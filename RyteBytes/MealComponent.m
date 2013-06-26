//
//  MenuComponent.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 4/13/13.
//
//

#import "MealComponent.h"

@implementation MealComponent

@synthesize name;
@synthesize description;
@synthesize type;
@synthesize price;
@synthesize nInfo;

-(id)init {
    self = [super init];
    return self;
}

-(id)initWithName:(NSString*)n withDescription:(NSString*)d withType:(MealComponentType)t withPrice:(double)p withNutritionInfo:(NutritionInfo*)ni {
    if(!(self = [super init]))
        return nil;
    
    name = n;
    description = d;
    type = t;
    price = p;
    nInfo = ni;
        
    return self;
}

@end
