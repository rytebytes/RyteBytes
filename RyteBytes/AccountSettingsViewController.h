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

@property (nonatomic,strong) IBOutlet UITableView *accountSettings;
@property (nonatomic,strong) IBOutlet UIButton *resetPassword;

@end
