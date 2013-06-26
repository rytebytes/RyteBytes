//
//  MenuCell.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 4/20/13.
//
//

#import "MenuCell.h"

@implementation MenuCell

@synthesize name;
@synthesize description;
@synthesize image;

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
