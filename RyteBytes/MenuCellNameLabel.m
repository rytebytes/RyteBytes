//
//  MenuCellNameLabel.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 1/9/14.
//
//

#import "MenuCellNameLabel.h"

@implementation MenuCellNameLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    self.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    self.layer.shadowRadius = 3.0;
    self.layer.shadowOpacity = 0.8;
//    self.layer.masksToBounds = NO;
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
