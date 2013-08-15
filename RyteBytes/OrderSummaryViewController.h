//
//  OrderController.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 5/11/13.
//
//

#import <UIKit/UIKit.h>

@interface OrderSummaryViewController : UIViewController

@property (nonatomic,strong) IBOutlet UITableView *orderSummary;
@property (nonatomic,strong) IBOutlet UILabel *orderTotal;
@property (nonatomic,strong) IBOutlet UILabel *doRyteTotal;
@property (nonatomic,strong) IBOutlet NSMutableDictionary *order;

@end
