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
#import "SVProgressHUD.h"
#import "Location.h"
#import "ParseClient.h"
#import "LocationResult.h"
#import "BeginLoginNavViewController.h"

@implementation LoginViewController

NSString *loginSuccessSegue = @"LoginSuccess";

long tagTextFieldToResign;

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
    self.navigationItem.hidesBackButton = NO;
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
            NSLog(@"reset password for %@", [[PFUser currentUser] valueForKey:@"email"]);
            [[[UIAlertView alloc] initWithTitle:@"Email sent."
                                        message:@"An email has been sent with a link to reset your password."
                                       delegate:nil
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles:nil] show];
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
        [SVProgressHUD showWithStatus:@"Updating location & menu" maskType:SVProgressHUDMaskTypeGradient];
        [PFUser logInWithUsernameInBackground:username password:password
            block:^(PFUser *user, NSError *error) {
                if(user){
                    ParseClient *parseClient = [ParseClient current];
                    NSString *locationId = [[[PFUser currentUser] valueForKey:USER_LOCATION] objectId];
                    [[Menu current] refreshFromServerWithOverlay:false];
                    
                    [parseClient POST:GetLocation parameters:[[NSDictionary alloc] initWithObjectsAndKeys:locationId,@"objectId",nil]
                              success:^(NSURLSessionDataTask *operation, id responseObject) {
                                  NSLog(@"Response object is : %@", responseObject);
                                  NSError *error = nil;
                                  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                  LocationResult *result = [[LocationResult alloc] initWithDictionary:responseObject error:&error];
                                  Location *locationInfo = result.result[0];
                                  [locationInfo writeToFile];
                              } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                                  NSLog(@"Error in sending request to get locations %@", [error localizedDescription]);
                              }
                     ];
                    
                    BeginLoginNavViewController *begin = (BeginLoginNavViewController*)self.navigationController;
                    if(begin.dismissHud)
                        [SVProgressHUD dismiss];
                    
                    [self.navigationController popToRootViewControllerAnimated:NO];
                } else {
                    [SVProgressHUD dismiss];
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
