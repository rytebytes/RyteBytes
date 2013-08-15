//
//  NutritionInfo.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 4/13/13.
//
//

#import <Foundation/Foundation.h>

@interface NutritionInformation : NSObject

@property int calories;
@property int protein;
@property int saturatedFat;
@property int sodium;

/**
 Calculate the ratio of sodium to calories.  Important because traditional frozen dinners
 have about 35% of your daily sodium, but only provide about 15% of your daily calories, their ratio
 2:1.  Since our meals run about 700 calories, which is about 30% of your daily calories,
 sodium ratio would be more inline (1:1 or less).
 
 @return The ratio of sodium to calories, as a decimal
*/
- (double) calculateSodiumToCalorieRatio;

/**
 Takes an array of nutrition information objects and sums up totals.
    
 @param listOfItems List of NutritionInformation objects to be included in summation
 @return A new object containing sums of all categories
*/
+ (NutritionInformation*) calculateInfoTotals:(NSArray *)listOfItems;

@end
