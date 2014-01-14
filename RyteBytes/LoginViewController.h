//
//  LoginOptionsViewController.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 6/27/13.
//
//

#import <Parse/Parse.h>

@protocol UserLoggedIn <NSObject>
- (void)checkForOutOfStockItems;
@end

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic,strong) IBOutlet UIView *loginView;
@property (nonatomic,strong) IBOutlet UITextField *email;
@property (nonatomic,strong) IBOutlet UITextField *password;
@property (nonatomic,strong) IBOutlet UIImageView *headerLogo;
@property (nonatomic,strong) IBOutlet UIButton *loginButton;

@end
