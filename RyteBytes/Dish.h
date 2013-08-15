//
//  MealComponent.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 3/29/13.
//
//

#import <Foundation/Foundation.h>
#import "MenuItem.h"

/**
 This is an object that represents a dish we have put together (i.e. RyteBytes Recommended).  It can be 3 separate components that
 we've decided to put together, or it can be a dish packaged in one bag (i.e. pastas).
 
 If it's an instance of the three separate components, then menuItem objects one,two, and three will be instantiated with those choices and
 the whole object will be null and vice-versa.
 
 */
@interface Dish : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *description;
@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,copy) MenuItem *menuItemOne;
@property (nonatomic,copy) MenuItem *menuItemTwo;
@property (nonatomic,copy) MenuItem *menuItemThree;
@property (nonatomic,copy) MenuItem *whole;

-(id)initWithName:(NSString*)n
 withDescription:(NSString*)d
 withItemOne:(MenuItem*)p
 withItemTwo:(MenuItem*)s
 withItemThree:(MenuItem*)v
 withWhole:(MenuItem*)w
 withImage:(NSString*)i;


@end
