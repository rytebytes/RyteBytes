//
//  OrderSummaryCell.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 5/11/13.
//
//

#import <UIKit/UIKit.h>

@interface OrderSummaryCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *itemName;
@property (nonatomic,strong) IBOutlet UILabel *quantity;
@property (nonatomic,strong) IBOutlet UILabel *totalCost;
@property (nonatomic,strong) IBOutlet UILabel *unitCost;
@property (nonatomic) NSString *uniqueId;

@property (nonatomic,strong) IBOutlet UIStepper *stepper;

@end
