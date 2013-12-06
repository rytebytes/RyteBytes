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
#import "CreateOrLoginViewController.h"

@implementation LoginViewController

NSString *loginSuccessSegue = @"LoginSuccess";

int tagTextFieldToResign;

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

-(void)dismissKeyboard
{
    [[self.view viewWithTag:tagTextFieldToResign] resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    tagTextFieldToResign = textField.tag;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL didResign = [textField resignFirstResponder];
    if(!didResign)
        return NO;
    
    if(textField.tag == TAG_UI_LOGIN_EMAIL)
    {
        [[self.view viewWithTag:TAG_UI_LOGIN_PASSWORD] becomeFirstResponder];
    }
    if(textField.tag == TAG_UI_LOGIN_PASSWORD)
    {
        [self attemptLogin:NULL];
    }
    return YES;
}
- (IBAction)cancelLogin:(id)sender
{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"LoginSuccess"])
    {
        NSLog(@"Currently logged in user email : %@", [PFUser currentUser].email);
        TabBarController *tabBar = (TabBarController *)segue.destinationViewController;
        tabBar.selectedIndex = ORDER_TAB;
    }
}

-(IBAction)resetPassword:(id)sender
{
    NSString *username = self.email.text;
    if(username && username.length != 0){
        PFQuery *emailExists = [PFUser query];
        [emailExists whereKey:@"username" equalTo:username];
        
        NSArray *user = [emailExists findObjects];
        
        if (user.count == 0) {
            [[[UIAlertView alloc] initWithTitle:@"Email invalid."
                                        message:@"Please enter a valid email."
                                       delegate:nil
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles:nil] show];
        }
        else{
            [PFUser requestPasswordResetForEmail:username];
        }
        
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Email missing."
                                    message:@"Please enter your email in the box before requesting to reset your password."
                                   delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil] show];
    }
}

-(IBAction)attemptLogin:(id)sender {
    
    NSString *username = self.email.text;
    NSString *password = self.password.text;
    
    if (username && password && username.length != 0 && password.length != 0)
    {
        //call to Parse to login
        //if successful,
        
        [PFUser logInWithUsernameInBackground:username password:password
            block:^(PFUser *user, NSError *error) {
                if(user){
//                    [self performSegueWithIdentifier:@"LoginSuccess" sender:nil];
                    CreateOrLoginViewController *parent = (CreateOrLoginViewController*)self.parentViewController;
                    [parent successFromViewController:self];
                    
//                    [self dismissViewControllerAnimated:true completion:nil];
//                    [self.parentViewController dismissViewControllerAnimated:false completion:nil];
                } else {
                    [[[UIAlertView alloc] initWithTitle:@"Login failed."
                                                message:@"Login information incorrect, please try again."
                                               delegate:nil
                                      cancelButtonTitle:@"Okay"
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
