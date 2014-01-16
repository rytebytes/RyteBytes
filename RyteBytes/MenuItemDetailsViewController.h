//
//  OrderController.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 4/20/13.
//
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import "MenuViewController.h"

@class MenuItemDetailsViewController;

@interface MenuItemDetailsViewController : UIViewController

@property (nonatomic,strong) MenuItem* menuItemSelected;
@property (nonatomic,strong) IBOutlet UIImageView *foodImageView;
@property (nonatomic,strong) IBOutlet UILabel *quantityOrdered;
@property (nonatomic,strong) IBOutlet UILabel *description;
@property (nonatomic,strong) IBOutlet UILabel *mealName;
@property (nonatomic,strong) IBOutlet UILabel *calories;
@property (nonatomic,strong) IBOutlet UILabel *carbs;
@property (nonatomic,strong) IBOutlet UILabel *sodium;
@property (nonatomic,strong) IBOutlet UILabel *protein;
@property (nonatomic,strong) IBOutlet UILabel *price;
@property (nonatomic,strong) IBOutlet UIStepper *quantityStepper;
@property (nonatomic,weak) id <MenuItemAdded> delegate;
@property (nonatomic,strong) NSString *currentAmountOrdered;
@property (nonatomic,strong) Order* currentOrder;

- (IBAction)valueChanged:(UIStepper *)sender;

@end
