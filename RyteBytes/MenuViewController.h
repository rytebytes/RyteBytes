//
//  PickMealViewController.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 3/29/13.
//
//

#import <UIKit/UIKit.h>
#import "Menu.h"
#import "MenuCell.h"

@protocol MenuItemAdded <NSObject>
- (void)setBadgeValue:(int)count;
@end

@interface MenuViewController : UITableViewController <MenuItemAdded,MenuRefresh>

//nonatomic - faster than atomic, no valid value guarantee
//copy - "pass by value" vs retain - "pass by reference"
@property (nonatomic,copy) NSString *kiosk;
//strong - keep on heap until nothing points to it
@property (nonatomic,strong) Menu *menu;
@property (nonatomic,strong) IBOutlet MenuCell *menuCell;

@end
