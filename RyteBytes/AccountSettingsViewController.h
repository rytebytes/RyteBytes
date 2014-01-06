//
//  AccountSettingsViewController.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 11/26/13.
//
//

#import <UIKit/UIKit.h>
#import "AccountEditCell.h"
#import "Constants.h"

@interface AccountSettingsViewController : UIViewController

@property (nonatomic,strong) IBOutlet UIButton *resetPassword;
@property (nonatomic,strong) IBOutlet UIButton *changeLocation;
@property (nonatomic,strong) IBOutlet UIButton *logout;
@property (nonatomic,strong) IBOutlet UIButton *changeCC;

@end
