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
@synthesize imageView;
@synthesize soldOut;

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    soldOut.hidden = YES;
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    name.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.75];
    // Configure the view for the selected state
}

@end
