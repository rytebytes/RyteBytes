//
//  MenuItemTests.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 9/4/13.
//
//

#import "MenuItemTests.h"
#import "MenuItem.h"
#import "Constants.h"

@implementation MenuItemTests

MenuItem *itemOne;
MenuItem *itemTwo;
MenuItem *itemThree;
NSMutableArray *itemArray;
NSString *jsonString;

NSString *ff_cals = @"600";
NSString *ff_carbs = @"50";
NSString *ff_protein = @"45";
NSString *ff_name = @"The Founders Favorite";
NSString *ff_type = @"3";
NSString *ff_desc = @"Our favorite meal to make when pressed for time - a delcious bone-in pork chop, roasted summer-fresh broccoli, and the broiled red potatoes tossed with fresh herbs and olive oil.";
NSString *ff_picture = @"blah.png";
NSString *ff_id = @"1";

NSString *rbr_cals = @"500";
NSString *rbr_carbs = @"40";
NSString *rbr_protein = @"50";
NSString *rbr_name = @"The Founders Favorite";
NSString *rbr_type = @"3";
NSString *rbr_desc = @"A meal that will remind your of mom's spaghetti & meatballs.  Whole-wheat linguine is tossed in our home-made 'gravy' (what the old time Italians call tomato sauce) that's based on a recipe from one of our italian grandmothers.  A trio of delicious italian sausage meatballs round out the meal!";
NSString *rbr_picture = @"foo.png";
NSString *rbr_id = @"2";

NSDictionary *result;

- (void)setUp
{   
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *ff_ni = [[NSMutableDictionary alloc] init];
    [ff_ni setValue:ff_cals forKey:@"calories"];
    [ff_ni setValue:ff_protein forKey:@"protein"];
    [ff_ni setValue:ff_carbs forKey:@"carbs"];
    
    NSMutableDictionary *ff = [[NSMutableDictionary alloc] init];
    [ff setValue:ff_name forKey:@"name"];
    [ff setValue:ff_type forKey:@"type"];
    [ff setValue:ff_desc forKey:@"long_description"];
    [ff setValue:ff_picture forKey:@"picture"];
    [ff setValue:ff_ni forKey:@"nutrition_info"];
    [ff setValue:ff_id forKey:@"uid"];
    
    NSMutableDictionary *rbr_ni = [[NSMutableDictionary alloc] init];
    [rbr_ni setValue:rbr_cals forKey:@"calories"];
    [rbr_ni setValue:rbr_protein forKey:@"protein"];
    [rbr_ni setValue:rbr_carbs forKey:@"carbs"];
    
    NSMutableDictionary *rbr = [[NSMutableDictionary alloc] init];
    [rbr setValue:rbr_name forKey:@"name"];
    [rbr setValue:rbr_type forKey:@"type"];
    [rbr setValue:rbr_desc forKey:@"long_description"];
    [rbr setValue:rbr_picture forKey:@"picture"];
    [rbr setValue:rbr_ni forKey:@"nutrition_info"];
    [rbr setValue:rbr_id forKey:@"uid"];
    
    items[0] = ff;
    items[1] = rbr;
    
    result = [[NSMutableDictionary alloc] init];
    [result setValue:items forKey:@"result"];
    
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testParsingMenuJsonWorksCorrectly
{
    @autoreleasepool {
        itemArray = [MenuItem convertMenuJsonToMenuItemArray:result];

        NSUInteger expectedCount = 2;
        
        STAssertEquals(expectedCount, [itemArray count],@"Should be 4 items in array");
        STAssertEqualObjects(ff_name, ((MenuItem*)itemArray[0]).name, @"Name of first MenuItem is 'The Founders Favorite'.");
        STAssertEquals(Whole, ((MenuItem*)itemArray[0]).type, @"Item types are correct");
        STAssertEquals(ff_id, ((MenuItem*)itemArray[0]).uniqueId, @"ids should match");
        
        
        STAssertEqualObjects(rbr_name, ((MenuItem*)itemArray[1]).name, @"Name of second MenuItem is 'Mob Meal I'.");
        STAssertEquals(rbr_id, ((MenuItem*)itemArray[1]).uniqueId, @"Name of second MenuItem is 'Mob Meal I'.");
    }
}

/* Test Menu Data:
 {
 "result" = [
 {
 "name" : "The Founders Favorite",
 "long_description":"Our favorite meal to make when pressed for time - a delcious bone-in pork chop, roasted summer-fresh broccoli, and the broiled red potatoes tossed with fresh herbs and olive oil.",
 "price":"13",
 "type" : "3",
 "picture":"images/missing_menu.png",
 "nutrition_info" : {
 "calories" : "600",
 "protein" : "40",
 "carbs" : "30"
 }
 },
 {
 "name" : "Mob Meal I",
 "long_description":"A meal that will remind your of mom's spaghetti & meatballs.  Whole-wheat linguine is tossed in our home-made 'gravy' (what the old time Italians call tomato sauce) that's based on a recipe from one of our italian grandmothers.  A trio of delicious italian sausage meatballs round out the meal!",
 "price":"10",
 "picture":"images/mob_meal_one.png",
 "nutrition_info" : {
 "calories" : "600",
 "protein" : "40",
 "carbs" : "30"
 }
 }
 ]
 }
 */


//    jsonString = @"{\"result\":[{\"name\":\"The Founders Favorite\",\"long_description\":\"Our favorite meal to make when pressed for time - a delcious bone-in pork chop, roasted summer-fresh broccoli, and the broiled red potatoes tossed with fresh herbs and olive oil.\",\"price\":\"13\",\"type\":\"3\",\"picture\":\"images/missing_menu.png\",\"nutrition_info\":{\"calories\":\"600\",\"protein\":\"40\",\"carbs\":\"30\"}},{\"name\":\"Mob Meal I\",\"long_description\":\"A meal that will remind your of spaghetti & meatballs.  Whole-wheat linguine is tossed in our home-made gravy (what the old time Italians call tomato sauce) based on a recipe from one of our italian grandmothers.  A trio of delicious italian sausage meatballs round out the meal!\",\"price\":\"10\",\"picture\":\"images/mob_meal_one.png\",\"nutrition_info\":{\"calories\":\"600\",\"protein\":\"40\",\"carbs\":\"30\"}},{\"name\":\"Mob Meal II\",\"long_description\":\"The same deliciousness of the original mob meal made with turkey for a leaner meatball.  All the fun with a fraction of the fat - what more could you ask for?!\",\"price\":\"13\",\"picture\":\"images/mob_meal_two.png\",\"nutrition_info\":{\"calories\":\"600\",\"protein\":\"40\",\"carbs\":\"30\"}},{\"name\":\"RyteBytes Recommended\",\"long_description\":\"Enjoy our ideal home cooked meal, without worrying about the cooking!  A perfectly grilled BBQ chicken breast, broiled red potatoes tossed in fresh herbs with roasted beets & carrots - healthy comfort food.\",\"price\":\"13\",\"picture\":\"images/chick_beets_taters.png\",\"nutrition_info\":{\"calories\":\"600\",\"protein\":\"40\",\"carbs\":\"30\"}}]}";
//
@end
