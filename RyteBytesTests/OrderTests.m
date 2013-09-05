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

@implementation OrderTests

Order *testingOrder;
MenuItem *itemOne;
MenuItem *itemTwo;
MenuItem *itemThree;
Dish *testDishOne;
Dish *testDishTwo;

//- (void)setUp
//{
//    [super setUp];
//    testingOrder = [Order current];
//    itemOne = [[MenuItem alloc] initWithName:@"Protein One" withPrice:6.00 withType:Protein withNutritionInfo:NULL];
//    itemTwo = [[MenuItem alloc] initWithName:@"Veg One" withPrice:2.00 withType:Vegetable withNutritionInfo:NULL];
//    itemThree = [[MenuItem alloc] initWithName:@"Starch One" withPrice:2.00 withType:Starch withNutritionInfo:NULL];
//    testDishOne = [[Dish alloc] initWithName:@"Test Dish One" withDescription:@"" withItemOne:itemOne withItemTwo:itemTwo withItemThree:itemThree withWhole:NULL withImage:NULL];
//    testDishTwo = [[Dish alloc] initWithName:@"Test Dish Two" withDescription:@"" withItemOne:itemOne withItemTwo:itemTwo withItemThree:itemThree withWhole:NULL withImage:NULL];
//}
//
//- (void)tearDown
//{
//    testingOrder = nil;
//    [super tearDown];
//}
//
//- (void)testAddDishToOrderFirstTimeUniqueCountIs1
//{
//    @autoreleasepool {
//        [testingOrder addDishToOrder:testDishOne];
//        STAssertEquals(1, [testingOrder getNumberUniqueDishes], @"Adding a dish for first time should return unique count of 1.");
//
//    }
//}
//
//- (void)testAddDifferentDishesIncreasesDishCount
//{
//    @autoreleasepool {
//        [testingOrder addDishToOrder:testDishOne];
//        [testingOrder addDishToOrder:testDishOne];
//        [testingOrder addDishToOrder:testDishTwo];
//        STAssertEquals(2, [testingOrder getNumberUniqueDishes], @"Adding two dishes should return unique count of 2.");
//    }
//}


@end
