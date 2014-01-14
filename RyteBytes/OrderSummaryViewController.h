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


@interface OrderSummaryViewController : UIViewController <UITableViewDataSource,UITableViewDelegate, UIAlertViewDelegate,UserLoggedIn,MenuRefresh>

@property (nonatomic,strong) IBOutlet UITableView *orderSummary;
@property (nonatomic,strong) IBOutlet UILabel *orderTotal;
@property (nonatomic,strong) IBOutlet UILabel *location;
@property (nonatomic,weak) id <MenuItemAdded> delegate;

- (IBAction)valueChanged:(UIStepper *)sender;
@end
