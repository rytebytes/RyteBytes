//
//  MenuCell.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 4/20/13.
//
//

#import <UIKit/UIKit.h>
#import "MenuCellNameLabel.h"

@interface MenuCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *name;
@property (nonatomic,strong) IBOutlet UILabel *soldOut;
@property (nonatomic,strong) IBOutlet UIImageView *imageView;

@end
