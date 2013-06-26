//
//  MealComponent.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 3/29/13.
//
//

#import "Meal.h"

@implementation Meal

@synthesize name;
@synthesize description;
@synthesize starch;
@synthesize vegetable;
@synthesize protein;
@synthesize imageName;

-(id)init {
    self = [super init];
    return self;
}

-(id)initWithName:(NSString*)n withDescription:(NSString*)d withProtein:(MealComponent*)p withStarch:(MealComponent*)s withVeg:(MealComponent*)v
withImage:(NSString*)i {
    if(!(self = [super init]))
        return nil;
    
    name = n;
    description = d;
    imageName = i;
    
    starch = s;
    vegetable = v;
    protein = p;
    
    return self;
}
@end
