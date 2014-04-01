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
#import "OrderItem.h"

@implementation OrderTests

Order *testingOrder;
LocationItem *itemOne;
LocationItem *itemTwo;
LocationItem *itemThree;
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
    
    itemOne = [[LocationItem alloc] init];
    itemOne.menuItemId.name = @"Potatoes";
    itemOne.menuItemId.nutritionInfoId = info;
    itemOne.objectId = @"a";

    itemTwo = [[LocationItem alloc] init];
    itemTwo.menuItemId.name = @"Beets & Carrots";
    itemTwo.menuItemId.nutritionInfoId = info;
    itemTwo.menuItemId.objectId = @"b";
    
    itemThree = [[LocationItem alloc] init];
    itemThree.menuItemId.name = @"BBQ Chicken";
    itemThree.menuItemId.nutritionInfoId = info;
    itemThree.objectId = @"c";
}

- (void)tearDown
{
    [testingOrder clearEntireOrder];
    [super tearDown];
}

-(void)getSpecificItemCountOnItemNotInOrder
{
    
}

-(void)testConvertToOrderItemArrayCopiesOrderCorrectly
{
    @autoreleasepool {
        [testingOrder setLocationItem:itemOne withQuantity:2];
        [testingOrder setLocationItem:itemTwo withQuantity:3];
        [testingOrder setLocationItem:itemThree withQuantity:4];
        
        NSMutableArray *orderArray = [testingOrder convertToOrderItemArray];
        
        NSInteger actualUnique = [orderArray count];
        
        STAssertEquals(3, actualUnique, @"Total order count should be the same");
        
        NSInteger totalCount = 0;
        totalCount += ((OrderItem*)orderArray[0]).quantity;
        totalCount += ((OrderItem*)orderArray[1]).quantity;
        totalCount += ((OrderItem*)orderArray[2]).quantity;
        
        
        STAssertEquals(9, totalCount, @"Total order count should be the same");
    }
}

-(void)testAddingRemovingItemsReturnsCorrectCount
{
    @autoreleasepool {
        [testingOrder setLocationItem:itemOne withQuantity:1];
        [testingOrder setLocationItem:itemTwo withQuantity:2];
        [testingOrder setLocationItem:itemThree withQuantity:1];
        
        STAssertEquals(1, [testingOrder getTotalItemCount], @"Adding a menu item for first time should return total count of 1.");
        STAssertEquals(1, [testingOrder getSpecificItemCount:itemOne.objectId], @"Menu item count should be 1." );
        
        [testingOrder setLocationItem:itemTwo withQuantity:1];
        [testingOrder setLocationItem:itemTwo withQuantity:0];
        
        STAssertEquals(0, [testingOrder getSpecificItemCount:itemTwo.objectId], @"Menu item count should be 0 after removing last item in order." );
        STAssertEquals(1, [testingOrder getNumberUniqueItems], @"Unique items only 1 after removing second unique item.");
 
        [testingOrder setLocationItem:itemTwo withQuantity:1];
        [testingOrder setLocationItem:itemTwo withQuantity:2];
        [testingOrder setLocationItem:itemTwo withQuantity:3];
        
        STAssertEquals(3, [testingOrder getSpecificItemCount:itemTwo.objectId], @"Menu item count should be 3." );
        STAssertEquals(2, [testingOrder getNumberUniqueItems], @"Unique items should be 2.");
    }
}

-(void)testAddSameMenuItemsToOrderReturnsCorrectCount
{
    @autoreleasepool {
        [testingOrder setLocationItem:itemTwo withQuantity:1];
        STAssertEquals(1, [testingOrder getTotalItemCount], @"Adding a menu item for first time should return total count of 1.");
        
        [testingOrder setLocationItem:itemTwo withQuantity:2];
        STAssertEquals(2, [testingOrder getTotalItemCount], @"Adding same menu item for second time should return total count of 2.");
        
        [testingOrder setLocationItem:itemTwo withQuantity:3];
        STAssertEquals(3, [testingOrder getTotalItemCount], @"Adding same menu item for third time should return total count of 3.");
        
        STAssertEquals(3, [testingOrder getSpecificItemCount:itemOne.objectId], @"Menu item count should be 3." );
        STAssertEquals(1, [testingOrder getNumberUniqueItems], @"Adding one menu item multiple times should return total unique count of 1.");
        
    }
}

-(void)testAddDifferentMenuItemsReturnsCorrectCount
{
    @autoreleasepool {
        [testingOrder setLocationItem:itemTwo withQuantity:1];
        [testingOrder setLocationItem:itemTwo withQuantity:1];
        
        STAssertEquals(2, [testingOrder getTotalItemCount], @"Adding two menu items should return total count of 2.");
        STAssertEquals(2, [testingOrder getNumberUniqueItems], @"Adding two menu items should return total unique count of 2.");
        
        [testingOrder setLocationItem:itemTwo withQuantity:1];
        STAssertEquals(3, [testingOrder getTotalItemCount], @"Adding three menu items should return total count of 3.");
        STAssertEquals(2, [testingOrder getNumberUniqueItems], @"Adding two menu items should return total unique count of 2.");
        STAssertEquals(2, [testingOrder getSpecificItemCount:itemTwo.objectId], @"Adding item twice should return specifc cound of 2.");
    }
}

@end
