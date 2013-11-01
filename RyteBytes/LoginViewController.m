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
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
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
        NSLog(@"Currently logged in user email : %@", [PFUser currentUser].email);
        TabBarController *tabBar = (TabBarController *)segue.destinationViewController;
        tabBar.selectedIndex = ORDER_TAB;
    }
}

- (IBAction)attemptLogin:(id)sender {
    
    NSString *username = self.email.text;
    NSString *password = self.password.text;
    
    if (username && password && username.length != 0 && password.length != 0)
    {
        //call to Parse to login
        //if successful,
        
        [PFUser logInWithUsernameInBackground:username password:password
            block:^(PFUser *user, NSError *error) {
                if(user){
                    [self performSegueWithIdentifier:loginSuccessSegue sender:nil];
                } else {
                    [[[UIAlertView alloc] initWithTitle:@"Login failed."
                                                message:@"Login information incorrect, please try again."
                                               delegate:nil
                                      cancelButtonTitle:@"ok"
                                      otherButtonTitles:nil] show];
                }
                                            
        }];
    } else {
        [[[UIAlertView alloc]
          initWithTitle:@"Missing Information"
          message:@"Make sure you fill out all of the information!"
          delegate:nil
          cancelButtonTitle:@"Try again."
          otherButtonTitles:nil] show];
    }
}

@end
