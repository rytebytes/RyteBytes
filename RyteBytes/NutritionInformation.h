//
//  NutritionInfo.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 4/13/13.
//
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface NutritionInformation : JSONModel

@property NSInteger calories;
@property NSInteger protein;
@property NSInteger sodium;
@property NSInteger carbs;

@property (nonatomic,strong) NSNumber<Optional> *saturatedFat;


-(id)initWithDictionary:(NSDictionary*)information;
-(double) calculateSodiumToCalorieRatio;
+(NutritionInformation*) calculateInfoTotals:(NSArray *)listOfItems;

@end
