//
//  LoginOptionsViewController.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 6/27/13.
//
//

#import "Parse/Parse.h"
#import "LoginViewController.h"
#import "TabBarController.h"

@implementation LoginViewController

NSString *loginSuccessSegue = @"LoginSuccess";
PFUser *currentUser;

@synthesize loginView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
      
    self.fields = PFLogInFieldsLogInButton;
//    | PFLogInFieldsDismissButton | PFLogInFieldsPasswordForgotten |
//    PFLogInFieldsUsernameAndPassword;
    self.delegate = self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    self.logInView.frame = CGRectMake(0, 300, 300, 300);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:loginSuccessSegue])
    {
        TabBarController *tabBar = (TabBarController *)segue.destinationViewController;
        tabBar.selectedIndex = DO_RYTE_TAB;
        tabBar.User = currentUser;
    }
}

- (void)logInViewController:(PFLogInViewController *)controller didLogInUser:(PFUser *)user
{
    currentUser = user;
    [self performSegueWithIdentifier:loginSuccessSegue sender:nil];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{
    NSLog(@"user canceled login.");
}

@end
