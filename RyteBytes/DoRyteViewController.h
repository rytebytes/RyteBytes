//
//  DoRyteViewController.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 11/25/13.
//
//

#import <UIKit/UIKit.h>

@interface DoRyteViewController : UIViewController

@property (nonatomic,strong) IBOutlet UIImage *charityLogo;
@property (nonatomic,strong) IBOutlet UILabel *charityName;
@property (nonatomic,strong) IBOutlet UILabel *charityContributionTotal;
@property (nonatomic,strong) IBOutlet UILabel *userContribution;

@end
