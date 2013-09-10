//
//  OrderTests.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 7/20/13.
//
//

#import "OrderTests.h"
#import "Order.h"
#import "MenuItem.h"
#import "Constants.h"
#import "NutritionInformation.h"

@implementation OrderTests

Order *testingOrder;
MenuItem *itemOne;
MenuItem *itemTwo;
MenuItem *itemThree;
NutritionInformation *info;
int calories = 500;
int carbs = 40;
int sodium = 300;
int protein = 50;

- (void)setUp
{
    [super setUp];
    testingOrder = [Order current];
    info = [[NutritionInformation alloc] init];
    info.calories = calories;
    info.carbs = carbs;
    info.sodium = sodium;
    info.protein = protein;
    
    itemOne = [[MenuItem alloc] initWithName:@"Potatoes" withType:Starch withNutritionInfo:info withPicture:@"" withLongDesc:@"" ];
    itemTwo = [[MenuItem alloc] initWithName:@"Beets & Carrots" withType:Starch withNutritionInfo:info withPicture:@"" withLongDesc:@"" ];
    itemThree = [[MenuItem alloc] initWithName:@"BBQ Chicken" withType:Starch withNutritionInfo:info withPicture:@"" withLongDesc:@"" ];
}

- (void)tearDown
{
    [testingOrder clearEntireOrder];
    [super tearDown];
}

-(void)testAddingRemovingItemsReturnsCorrectCount
{
    @autoreleasepool {
        [testingOrder setMenuItemQuantity:itemOne withQuantity:1];
        [testingOrder setMenuItemQuantity:itemOne withQuantity:2];
        [testingOrder setMenuItemQuantity:itemOne withQuantity:1];
        
        STAssertEquals(1, [testingOrder getTotalItemCount], @"Adding a menu item for first time should return total count of 1.");
        STAssertEquals(1, [testingOrder getSpecificMenuItemCount:itemOne.name], @"Menu item count should be 1." );
        
        [testingOrder setMenuItemQuantity:itemTwo withQuantity:1];
        [testingOrder setMenuItemQuantity:itemTwo withQuantity:0];
        
        STAssertEquals(0, [testingOrder getSpecificMenuItemCount:itemTwo.name], @"Menu item count should be 0 after removing last item in order." );
        STAssertEquals(1, [testingOrder getNumberUniqueItems], @"Unique items only 1 after removing second unique item.");
 
        [testingOrder setMenuItemQuantity:itemTwo withQuantity:1];
        [testingOrder setMenuItemQuantity:itemTwo withQuantity:2];
        [testingOrder setMenuItemQuantity:itemTwo withQuantity:3];
        
        STAssertEquals(3, [testingOrder getSpecificMenuItemCount:itemTwo.name], @"Menu item count should be 3." );
        STAssertEquals(2, [testingOrder getNumberUniqueItems], @"Unique items should be 2.");
    }
}

-(void)testAddSameMenuItemsToOrderReturnsCorrectCount
{
    @autoreleasepool {
        [testingOrder setMenuItemQuantity:itemOne withQuantity:1];
        STAssertEquals(1, [testingOrder getTotalItemCount], @"Adding a menu item for first time should return total count of 1.");
        
        [testingOrder setMenuItemQuantity:itemOne withQuantity:2];
        STAssertEquals(2, [testingOrder getTotalItemCount], @"Adding same menu item for second time should return total count of 2.");
        
        [testingOrder setMenuItemQuantity:itemOne withQuantity:3];
        STAssertEquals(3, [testingOrder getTotalItemCount], @"Adding same menu item for third time should return total count of 3.");
        
        STAssertEquals(3, [testingOrder getSpecificMenuItemCount:itemOne.name], @"Menu item count should be 3." );
        STAssertEquals(1, [testingOrder getNumberUniqueItems], @"Adding one menu item multiple times should return total unique count of 1.");
        
    }
}

-(void)testAddDifferentMenuItemsReturnsCorrectCount
{
    @autoreleasepool {
        [testingOrder setMenuItemQuantity:itemOne withQuantity:1];
        [testingOrder setMenuItemQuantity:itemTwo withQuantity:1];
        
        STAssertEquals(2, [testingOrder getTotalItemCount], @"Adding two menu items should return total count of 2.");
        STAssertEquals(2, [testingOrder getNumberUniqueItems], @"Adding two menu items should return total unique count of 2.");
        
        [testingOrder setMenuItemQuantity:itemTwo withQuantity:2];
        STAssertEquals(3, [testingOrder getTotalItemCount], @"Adding three menu items should return total count of 3.");
        STAssertEquals(2, [testingOrder getNumberUniqueItems], @"Adding two menu items should return total unique count of 2.");
        STAssertEquals(2, [testingOrder getSpecificMenuItemCount:itemTwo.name], @"Adding item twice should return specifc cound of 2.");
    }
}

@end
