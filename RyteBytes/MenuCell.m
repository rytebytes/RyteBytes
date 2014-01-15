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
    NSLog(@"in selected");

//
    // Configure the view for the selected state
}

@end
