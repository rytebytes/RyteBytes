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

@interface OrderSummaryViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView *orderSummary;
@property (nonatomic,strong) IBOutlet UILabel *orderTotal;
@property (nonatomic,strong) IBOutlet UILabel *doRyteTotal;
@property (nonatomic,weak) id <MenuItemAdded> delegate;

- (IBAction)valueChanged:(UIStepper *)sender;
@end
