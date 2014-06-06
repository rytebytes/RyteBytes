//
//  OrderController.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 5/11/13.
//
//

#import <UIKit/UIKit.h>
#import "MenuItemDetailsViewController.h"
#import "MenuViewController.h"
#import "LoginViewController.h"
#import "Menu.h"


@interface OrderSummaryViewController : UIViewController <UITableViewDataSource,UITableViewDelegate, UIAlertViewDelegate,UserLoggedIn,OrderUpdatedWithNewMenu>

@property (nonatomic,strong) IBOutlet UITableView *orderSummary;
@property (nonatomic,strong) IBOutlet UILabel *orderTotal;
@property (nonatomic,strong) IBOutlet UILabel *location;
@property (nonatomic,weak) id <MenuItemAdded> delegate;
@property (nonatomic,strong) IBOutlet UIButton *coupon;

- (IBAction)valueChanged:(UIStepper *)sender;
@end
