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
@property (nonatomic,strong) NutritionInformation *nutritionInfo;
@property (nonatomic,strong) NSString *picture;
@property (nonatomic,strong) NSString *longDescription;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic) int cost;

//+(NSMutableArray*) convertMenuJsonToMenuItemArray:(NSDictionary*)menuJson;
//+(void) writeMenuToDisk:(NSDictionary*)menuJson;
//+(NSMutableArray*) retrieveMenuFromDisk;
//-(id)initWithName:(NSString*)n withType:(MenuItemTypes)t withNutritionInfo:(NutritionInformation*)info withPicture:(NSString*)p withLongDesc:(NSString*)d
//          withUid:(NSString*)uid withCost:(int)c;

@end
