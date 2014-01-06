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

StripeCustomer *stripeCustomerInfo = nil;

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
        [PFUser requestPasswordResetForEmail:[currentUser valueForKey:@"email"]];
    }
    else
    {
        TabBarController *tab = (TabBarController*)self.parentViewController.parentViewController;
        [tab showLogin];
    }
}

//update credit card info in this method
- (void)viewWillAppear:(BOOL)animated
{
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser)
    {
        logout.hidden = FALSE;
        NSString *url = [[NSString alloc] initWithFormat:ExistingCustomerFormat,[[PFUser currentUser] valueForKey:STRIPE_ID]];
        
        //make call to stripe to get the user's current CC info
        [[StripeClient current] GET:url
             parameters:[[NSDictionary alloc] init]
                success:^(NSURLSessionDataTask *operation, id responseObject) {
                    NSError *error = nil;
                    stripeCustomerInfo = [[StripeCustomer alloc] initWithDictionary:responseObject error:&error];
                }
                failure:^(NSURLSessionDataTask *operation, NSError *error) {
                    NSError *modelConversionError;
                    StripeError *stripeError = [[StripeErrorResponse alloc] initWithString:error.userInfo[JSONResponseSerializerWithDataKey] error:&modelConversionError].error;
                    NSLog(@"Error returned retrieving stripe info. Code:%@ . Message : %@", stripeError.code, stripeError.message);
                }
         ];
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
        [tab showLogin];
        return NO;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ChangeCC"] && nil != stripeCustomerInfo)
    {
        ChangeCreditCardViewController *destination = (ChangeCreditCardViewController*)segue.destinationViewController;
        destination.stripeInfo = stripeCustomerInfo;
    }
    else if ([segue.identifier isEqualToString:@"ChangePickupLocation"])
    {
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
