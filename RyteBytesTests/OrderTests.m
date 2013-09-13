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
    
    itemOne = [[MenuItem alloc] initWithName:@"Potatoes" withType:Starch withNutritionInfo:info withPicture:@"" withLongDesc:@"" withUid:@"0"];
    itemTwo = [[MenuItem alloc] initWithName:@"Beets & Carrots" withType:Starch withNutritionInfo:info withPicture:@"" withLongDesc:@"" withUid:@"1"];
    itemThree = [[MenuItem alloc] initWithName:@"BBQ Chicken" withType:Starch withNutritionInfo:info withPicture:@"" withLongDesc:@"" withUid:@"2"];
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
        [testingOrder setOrderItemQuantity:[[OrderItem alloc] initWithMenuItem:itemOne] withQuantity:2];
        [testingOrder setOrderItemQuantity:[[OrderItem alloc] initWithMenuItem:itemTwo] withQuantity:3];
        [testingOrder setOrderItemQuantity:[[OrderItem alloc] initWithMenuItem:itemThree] withQuantity:4];
        
        NSMutableArray *orderArray = [testingOrder convertToOrderItemArray];
        
        NSInteger actualUnique = [orderArray count];
        
        STAssertEquals(3, actualUnique, @"Total order count should be the same");
        
        NSInteger totalCount = 0;
        totalCount += ((OrderItem*)orderArray[0]).orderCount;
        totalCount += ((OrderItem*)orderArray[1]).orderCount;
        totalCount += ((OrderItem*)orderArray[2]).orderCount;
        
        
        STAssertEquals(9, totalCount, @"Total order count should be the same");
    }
}

-(void)testAddingRemovingItemsReturnsCorrectCount
{
    @autoreleasepool {
        [testingOrder setOrderItemQuantity:[[OrderItem alloc] initWithMenuItem:itemOne] withQuantity:1];
        [testingOrder setOrderItemQuantity:[[OrderItem alloc] initWithMenuItem:itemOne] withQuantity:2];
        [testingOrder setOrderItemQuantity:[[OrderItem alloc] initWithMenuItem:itemOne] withQuantity:1];
        
        STAssertEquals(1, [testingOrder getTotalItemCount], @"Adding a menu item for first time should return total count of 1.");
        STAssertEquals(1, [testingOrder getSpecificItemCount:itemOne.uniqueId], @"Menu item count should be 1." );
        
        [testingOrder setOrderItemQuantity:[[OrderItem alloc] initWithMenuItem:itemTwo] withQuantity:1];
        [testingOrder setOrderItemQuantity:[[OrderItem alloc] initWithMenuItem:itemTwo] withQuantity:0];
        
        STAssertEquals(-1, [testingOrder getSpecificItemCount:itemTwo.uniqueId], @"Menu item count should be 0 after removing last item in order." );
        STAssertEquals(1, [testingOrder getNumberUniqueItems], @"Unique items only 1 after removing second unique item.");
 
        [testingOrder setOrderItemQuantity:[[OrderItem alloc] initWithMenuItem:itemTwo] withQuantity:1];
        [testingOrder setOrderItemQuantity:[[OrderItem alloc] initWithMenuItem:itemTwo] withQuantity:2];
        [testingOrder setOrderItemQuantity:[[OrderItem alloc] initWithMenuItem:itemTwo] withQuantity:3];
        
        STAssertEquals(3, [testingOrder getSpecificItemCount:itemTwo.uniqueId], @"Menu item count should be 3." );
        STAssertEquals(2, [testingOrder getNumberUniqueItems], @"Unique items should be 2.");
    }
}

-(void)testAddSameMenuItemsToOrderReturnsCorrectCount
{
    @autoreleasepool {
        [testingOrder setOrderItemQuantity:[[OrderItem alloc] initWithMenuItem:itemOne] withQuantity:1];
        STAssertEquals(1, [testingOrder getTotalItemCount], @"Adding a menu item for first time should return total count of 1.");
        
        [testingOrder setOrderItemQuantity:[[OrderItem alloc] initWithMenuItem:itemOne] withQuantity:2];
        STAssertEquals(2, [testingOrder getTotalItemCount], @"Adding same menu item for second time should return total count of 2.");
        
        [testingOrder setOrderItemQuantity:[[OrderItem alloc] initWithMenuItem:itemOne] withQuantity:3];
        STAssertEquals(3, [testingOrder getTotalItemCount], @"Adding same menu item for third time should return total count of 3.");
        
        STAssertEquals(3, [testingOrder getSpecificItemCount:itemOne.uniqueId], @"Menu item count should be 3." );
        STAssertEquals(1, [testingOrder getNumberUniqueItems], @"Adding one menu item multiple times should return total unique count of 1.");
        
    }
}

-(void)testAddDifferentMenuItemsReturnsCorrectCount
{
    @autoreleasepool {
        [testingOrder setOrderItemQuantity:[[OrderItem alloc] initWithMenuItem:itemOne] withQuantity:1];
        [testingOrder setOrderItemQuantity:[[OrderItem alloc] initWithMenuItem:itemTwo] withQuantity:1];
        
        STAssertEquals(2, [testingOrder getTotalItemCount], @"Adding two menu items should return total count of 2.");
        STAssertEquals(2, [testingOrder getNumberUniqueItems], @"Adding two menu items should return total unique count of 2.");
        
        [testingOrder setOrderItemQuantity:[[OrderItem alloc] initWithMenuItem:itemTwo] withQuantity:2];
        STAssertEquals(3, [testingOrder getTotalItemCount], @"Adding three menu items should return total count of 3.");
        STAssertEquals(2, [testingOrder getNumberUniqueItems], @"Adding two menu items should return total unique count of 2.");
        STAssertEquals(2, [testingOrder getSpecificItemCount:itemTwo.uniqueId], @"Adding item twice should return specifc cound of 2.");
    }
}

@end
