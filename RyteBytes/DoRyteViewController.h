//
//  DoRyteViewController.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 11/25/13.
//
//

#import <UIKit/UIKit.h>

@interface DoRyteViewController : UIViewController

@property (nonatomic,strong) IBOutlet UIImageView *charityLogo;
@property (nonatomic,strong) IBOutlet UILabel *charityName;
@property (nonatomic,strong) IBOutlet UILabel *charityContributionTotal;
@property (nonatomic,strong) IBOutlet UILabel *noUserMessage;
@property (nonatomic,strong) IBOutlet UILabel *charityContributionTotalLabel;
@property (nonatomic,strong) IBOutlet UILabel *charityDescription;

@end
