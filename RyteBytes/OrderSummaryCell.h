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
@property (nonatomic,strong) IBOutlet UILabel *quantityAndUnitCost;
@property (nonatomic,strong) IBOutlet UILabel *totalItemCost;
@property (nonatomic,strong) IBOutlet UIImageView *image;
@property (nonatomic) NSString *uniqueId;

@property (nonatomic,strong) IBOutlet UIStepper *stepper;

@end
