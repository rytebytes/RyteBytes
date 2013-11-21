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

-(id)initWithDictionary:(NSDictionary*)information
{
    NutritionInformation *info = [[NutritionInformation alloc] init];

    info.calories = [[information valueForKey:@"calories"] integerValue];
    info.protein = [[information valueForKey:@"protein"] integerValue];
//    info.sodium = [[information valueForKey:@"sodium"] integerValue];
    info.carbs = [[information valueForKey:@"carbs"] integerValue];
    
    return info;
}

/**
 Calculate the ratio of sodium to calories.  Important because traditional frozen dinners
 have about 35% of your daily sodium, but only provide about 15% of your daily calories, their ratio
 2:1.  Since our meals run about 700 calories, which is about 30% of your daily calories,
 sodium ratio would be more inline (1:1 or less).
 
 @return The ratio of sodium to calories, as a decimal
 */
- (double)calculateSodiumToCalorieRatio
{
    return 1.0;
}

/**
 Takes an array of nutrition information objects and sums up totals.
 
 @param listOfItems List of NutritionInformation objects to be included in summation
 @return A new object containing sums of all categories
 */
+ (NutritionInformation*) calculateInfoTotals:(NSArray *)listOfItems
{
    return NULL;
}

@end
