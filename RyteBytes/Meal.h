//
//  MealComponent.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 3/29/13.
//
//

#import <Foundation/Foundation.h>
#import "Enums.h"
#import "MealComponent.h"

@interface Meal : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *description;
@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,copy) MealComponent *starch;
@property (nonatomic,copy) MealComponent *vegetable;
@property (nonatomic,copy) MealComponent *protein;

-(id)initWithName:(NSString*)n withDescription:(NSString*)d withProtein:(MealComponent*)p withStarch:(MealComponent*)s withVeg:(MealComponent*)v withImage:(NSString*)i;

@end
