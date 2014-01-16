//
//  OrderSummaryCell.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 5/11/13.
//
//

#import "OrderSummaryCell.h"

@implementation OrderSummaryCell

@synthesize itemName;
@synthesize stepper;
@synthesize uniqueId;
@synthesize image;
@synthesize quantityAndUnitCost;
@synthesize totalItemCost;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
