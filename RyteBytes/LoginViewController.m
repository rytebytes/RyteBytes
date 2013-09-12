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
        tabBar.selectedIndex = ORDER_TAB;
    }
}

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password
{
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0)
    {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

- (void)logInViewController:(PFLogInViewController *)controller didLogInUser:(PFUser *)user
{
    [self performSegueWithIdentifier:loginSuccessSegue sender:nil];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{
    NSLog(@"user canceled login.");
}

@end
