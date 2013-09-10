//
//  NutritionInfo.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 4/13/13.
//
//

#import <Foundation/Foundation.h>

@interface NutritionInformation : NSObject

@property NSInteger calories;
@property NSInteger protein;
@property NSInteger saturatedFat;
@property NSInteger sodium;
@property NSInteger carbs;

-(id)initWithDictionary:(NSDictionary*)information;
-(double) calculateSodiumToCalorieRatio;
+(NutritionInformation*) calculateInfoTotals:(NSArray *)listOfItems;

@end
