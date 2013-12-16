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

@synthesize accountSettings;
@synthesize resetPassword;

StripeCustomer *stripeCustomerInfo = nil;

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
	// Do any additional setup after loading the view.
    
    AccountEditCell *cc = (AccountEditCell*)[self.accountSettings cellForRowAtIndexPath:[[NSIndexPath alloc] initWithIndex:0]];
    cc.label = @"Edit Credit Card";
    
    AccountEditCell *pickup = (AccountEditCell*)[self.accountSettings cellForRowAtIndexPath:[[NSIndexPath alloc] initWithIndex:1]];
    pickup.label = @"Change Pickup Location";
    
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
                         }];
    
    
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
}

//update credit card info in this method
- (void)viewWillAppear:(BOOL)animated
{
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
