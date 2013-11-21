//
//  MenuItem.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 7/20/13.
//
//

#import "MenuItem.h"
#import "SBJson.h"
#import "Constants.h"

@implementation MenuItem

/**@synthesize nutritionInfo;
@synthesize pictureName;
@synthesize name;
@synthesize type;
@synthesize longDescription;
@synthesize uniqueId;
@synthesize cost;

-(id)initWithName:(NSString*)n withType:(MenuItemTypes)t withNutritionInfo:(NutritionInformation*)info withPicture:(NSString*)p withLongDesc:(NSString*)d
          withUid:(NSString*)uid withCost:(int)c
{
    if(!(self = [super init]))
        return nil;
    
    name = n;
    type = (MenuItemTypes)t;
    nutritionInfo = info;
    pictureName = p;
    longDescription = d;
    uniqueId = uid;
    cost = c;
    
    return self;
}

 Converts JSON returned from web service into an array of menu items for use within the application.
 Expects the following json format:
 {
    "result" = [
        {
            "name" = "<name of item>",
            "long_description" = "<long description text>",
            "picture" = "<picture name>",
            "type" = "<int>",
            "nutrition_info" = 
                {
                    "calories" = "<cals>",
                    "carbs" = "<carbs>",
                    "protein" = "<protein>",
                }
        }
    ]
 }
 
 @param menuJson the json returned from the server
 @returns Returns the array of menu items

+(NSMutableArray*) convertMenuJsonToMenuItemArray:(NSDictionary*)menuJson
{
    NSArray *itemArray = [menuJson objectForKey:@"result"];
    
    NSMutableArray *menuItemArray = [[NSMutableArray alloc] initWithCapacity:[itemArray count]];
    
    for (int count = 0; count < [itemArray count]; count++) {
        NSDictionary *item = itemArray[count];
        menuItemArray[count] = [[MenuItem alloc]
                                initWithName:[item valueForKey:@"name"]
                                withType:[[item valueForKey:@"type"] intValue]
                                withNutritionInfo:[[NutritionInformation alloc] initWithDictionary:[item valueForKey:@"nutrition_info"]]
                                withPicture:[item valueForKey:@"picture"]
                                withLongDesc:[item valueForKey:@"long_description"]
                                withUid:[item valueForKey:@"uid"]
                                withCost:[item valueForKey:@"cost"]];
    }

    return menuItemArray;
}

+(void) writeMenuToDisk:(NSDictionary*)menuJson
{
    
}

+(NSMutableArray*) retrieveMenuFromDisk
{
    return NULL;
} */

@end
