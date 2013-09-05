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
         },
         {
            "name" : "Mob Meal II",
            "long_description":"The same deliciousness of the original mob meal made with turkey for a leaner meatball.  All the fun with a fraction of the fat - what more could you ask for?!",
            "price":"13",
            "picture":"images/mob_meal_two.png",
            "nutrition_info" : {
                "calories" : "600",
                "protein" : "40",
                "carbs" : "30"
            }
         },
         {
            "name" : "RyteBytes Recommended",
            "long_description":"Enjoy our ideal home cooked meal, without worrying about the cooking!  A perfectly grilled BBQ chicken breast, broiled red potatoes tossed in fresh herbs with roasted beets & carrots - healthy comfort food.",
            "price":"13",
            "picture":"images/chick_beets_taters.png",
            "nutrition_info" : {
                "calories" : "600",
                "protein" : "40",
                "carbs" : "30"
            }
         }
     ]
 }
 */

- (void)setUp
{
    jsonString = @"{\"result\":[{\"name\":\"The Founders Favorite\",\"long_description\":\"Our favorite meal to make when pressed for time - a delcious bone-in pork chop, roasted summer-fresh broccoli, and the broiled red potatoes tossed with fresh herbs and olive oil.\",\"price\":\"13\",\"type\":\"3\",\"picture\":\"images/missing_menu.png\",\"nutrition_info\":{\"calories\":\"600\",\"protein\":\"40\",\"carbs\":\"30\"}},{\"name\":\"Mob Meal I\",\"long_description\":\"A meal that will remind your of spaghetti & meatballs.  Whole-wheat linguine is tossed in our home-made gravy (what the old time Italians call tomato sauce) based on a recipe from one of our italian grandmothers.  A trio of delicious italian sausage meatballs round out the meal!\",\"price\":\"10\",\"picture\":\"images/mob_meal_one.png\",\"nutrition_info\":{\"calories\":\"600\",\"protein\":\"40\",\"carbs\":\"30\"}},{\"name\":\"Mob Meal II\",\"long_description\":\"The same deliciousness of the original mob meal made with turkey for a leaner meatball.  All the fun with a fraction of the fat - what more could you ask for?!\",\"price\":\"13\",\"picture\":\"images/mob_meal_two.png\",\"nutrition_info\":{\"calories\":\"600\",\"protein\":\"40\",\"carbs\":\"30\"}},{\"name\":\"RyteBytes Recommended\",\"long_description\":\"Enjoy our ideal home cooked meal, without worrying about the cooking!  A perfectly grilled BBQ chicken breast, broiled red potatoes tossed in fresh herbs with roasted beets & carrots - healthy comfort food.\",\"price\":\"13\",\"picture\":\"images/chick_beets_taters.png\",\"nutrition_info\":{\"calories\":\"600\",\"protein\":\"40\",\"carbs\":\"30\"}}]}";
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testAddDishToOrderFirstTimeUniqueCountIs1
{
    @autoreleasepool {
        itemArray = [MenuItem convertMenuJsonToMenuItemArray:jsonString];

        NSUInteger expectedCount = 4;
        
        STAssertEquals(expectedCount, [itemArray count],@"Should be 4 items in array");
        STAssertEqualObjects(@"The Founders Favorite", ((MenuItem*)itemArray[0]).name, @"Name of first MenuItem is 'The Founders Favorite'.");
        STAssertEquals(Whole, ((MenuItem*)itemArray[0]).type, @"Item types are correct");
        
        STAssertEqualObjects(@"Mob Meal I", ((MenuItem*)itemArray[1]).name, @"Name of second MenuItem is 'Mob Meal I'.");
        STAssertEqualObjects(@"Mob Meal II", ((MenuItem*)itemArray[2]).name, @"Name of first MenuItem is 'Mob Meal II'.");
        STAssertEqualObjects(@"RyteBytes Recommended", ((MenuItem*)itemArray[3]).name, @"Name of first MenuItem is 'RyteBytes Recommended'.");
    }
}
@end
