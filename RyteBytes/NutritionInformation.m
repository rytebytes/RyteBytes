//
//  NutritionInfo.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 4/13/13.
//
//

#import "NutritionInformation.h"

@implementation NutritionInformation

@synthesize calories;
@synthesize saturatedFat;
@synthesize sodium;
@synthesize protein;

- (double)calculateSodiumToCalorieRatio
{
    return 1.0;
}

+ (NutritionInformation*) calculateInfoTotals:(NSArray *)listOfItems
{
    return NULL;
}

@end
