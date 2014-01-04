//
//  LoginController.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 6/22/13.
//
//

#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "TabBarController.h"

@interface CreateOrLoginViewController : UIViewController

@property (nonatomic,strong) IBOutlet UIBarButtonItem *backBtn;
@property (nonatomic,strong) IBOutlet UIButton *signIn;
@property (nonatomic,strong) IBOutlet UIButton *createAccount;

@end
