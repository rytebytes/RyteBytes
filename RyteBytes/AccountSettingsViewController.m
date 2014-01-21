//
//  AccountSettingsViewController.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 11/26/13.
//
//

#import "AccountSettingsViewController.h"
#import "StripeCustomer.h"
#import "StripeClient.h"
#import "StripeErrorResponse.h"
#import "StripeError.h"
#import "JSONResponseSerializerWithData.h"
#import "Parse/Parse.h"
#import "ChangeCreditCardViewController.h"
#import "Order.h"
#import "TabBarController.h"

@implementation AccountSettingsViewController

@synthesize resetPassword;
@synthesize logout;
@synthesize changeLocation;
@synthesize changeCC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)logout:(id)sender
{
    [PFUser logOut];
    [[Order current] clearEntireOrder];
    [[Menu current] clearMenu];
    [[Menu current] refreshFromServerWithOverlay:false];
    TabBarController *tab = (TabBarController*)self.parentViewController.parentViewController;
    UINavigationController *menu = [tab viewControllers][1];
    menu.tabBarItem.badgeValue = nil;
    
    UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success." message:@"You are now logged out." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [success show];
    logout.hidden = TRUE;
}

- (IBAction)resetPassword:(id)sender
{
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser)
    {
        [[[UIAlertView alloc] initWithTitle:@"Email sent."
                                    message:@"An email has been sent with a link to reset your password."
                                   delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil] show];
        NSLog(@"reset password for %@", [currentUser valueForKey:@"email"]);
        [PFUser requestPasswordResetForEmail:[currentUser valueForKey:@"email"]];
    }
    else
    {
        TabBarController *tab = (TabBarController*)self.parentViewController.parentViewController;
        [tab showLoginDismissHUDOnSuccess:TRUE];
    }
}

//update credit card info in this method
- (void)viewWillAppear:(BOOL)animated
{
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser)
    {
        logout.hidden = FALSE;
        [currentUser refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            NSLog(@"Refreshing user from Parse completed.");
        }];
    }
    else
    {
        logout.hidden = TRUE;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser)
    {
        return YES;
    }
    else
    {
        TabBarController *tab = (TabBarController*)self.parentViewController.parentViewController;
        [tab showLoginDismissHUDOnSuccess:TRUE];
        return NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
