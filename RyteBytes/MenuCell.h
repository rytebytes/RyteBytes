//
//  MenuCell.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 4/20/13.
//
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *name;
@property (nonatomic,strong) IBOutlet UILabel *description;
@property (nonatomic,strong) IBOutlet UIImageView *image;

@end
