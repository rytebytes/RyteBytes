//
//  OrderSummaryCell.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 5/11/13.
//
//

#import <UIKit/UIKit.h>

@interface OrderSummaryCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *mealName;
@property (nonatomic,strong) IBOutlet UILabel *quantity;

@end
