//
//  MenuItem.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 7/20/13.
//
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "NutritionInformation.h"
#import "JSONModel.h"

@protocol MenuItem
@end

@interface MenuItem : JSONModel

//@property (nonatomic) MenuItemTypes type;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NutritionInformation *nutritionInfoId;
@property (nonatomic,strong) NSString *picture;
@property (nonatomic,strong) NSString *longDescription;
@property (nonatomic,strong) NSString *objectId;
@property (nonatomic) int costInCents;

@end