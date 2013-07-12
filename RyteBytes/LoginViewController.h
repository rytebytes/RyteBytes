//
//  LoginOptionsViewController.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 6/27/13.
//
//

#import <Parse/Parse.h>

@interface LoginViewController : PFLogInViewController <PFLogInViewControllerDelegate>

@property (nonatomic,strong) IBOutlet UIView *loginView;

@end
