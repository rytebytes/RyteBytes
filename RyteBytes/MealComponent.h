//
//  MenuComponent.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 4/13/13.
//
//

#import <Foundation/Foundation.h>
#import "Enums.h"
#import "NutritionInfo.h"

@interface MealComponent : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *description;
@property (nonatomic) MealComponentType type;
@property (nonatomic) double price;
@property (nonatomic,copy) NutritionInfo *nInfo;

-(id)initWithName:(NSString*)n withDescription:(NSString*)d withType:(MealComponentType)t withPrice:(double)p withNutritionInfo:(NutritionInfo*)ni;

@end
