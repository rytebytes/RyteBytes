//
//  MenuCell.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 4/20/13.
//
//

#import "MenuCell.h"
#include <Quartzcore/Quartzcore.h>

@implementation MenuCell

@synthesize name;
@synthesize imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    name.layer.shadowColor = [UIColor orangeColor].CGColor;
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    name.backgroundColor = [UIColor whiteColor];
    // Configure the view for the selected state
}

@end
