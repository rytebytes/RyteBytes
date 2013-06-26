//
//  MealComponentController.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 3/29/13.
//
//

#import <UIKit/UIKit.h>
#import "Enums.h"
#import "MealQuantityController.h"

@interface MenuController : UITableViewController <MealAdded>

//nonatomic - faster than atomic, no valid value guarantee
//copy - "pass by value" vs retain - "pass by reference"
@property (nonatomic,copy) NSString *kiosk;
//strong - keep on heap until nothing points to it
@property (nonatomic,strong) NSMutableArray *menuItems;

-(void)generateMenuData;

@end
