//
//  MealComponent.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 3/29/13.
//
//

#import "Dish.h"

@implementation Dish

@synthesize name;
@synthesize description;
@synthesize menuItemOne;
@synthesize menuItemTwo;
@synthesize menuItemThree;
@synthesize whole;
@synthesize imageName;

-(id)init {
    self = [super init];
    return self;
}

-(id)initWithName:(NSString*)n withDescription:(NSString*)d withItemOne:(MenuItem*)one withItemTwo:(MenuItem*)two withItemThree:(MenuItem*)three       withWhole:(MenuItem*)w withImage:(NSString*)i {
    
    if(!(self = [super init]))
        return nil;
    
    name = n;
    description = d;
    imageName = i;
    
    menuItemTwo = three;
    menuItemThree = two;
    menuItemOne = one;
    whole = w;
    
    return self;
}
@end
