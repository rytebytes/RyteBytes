//
//  ChangePickupLocationViewController.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 11/26/13.
//
//

#import "ChangePickupLocationViewController.h"
#import "LocationResult.h"
#import "ParseClient.h"
#import <Parse/Parse.h>
#import "Constants.h"
#import "SVProgressHUD.h"
#import "Order.h"
#import "TabBarController.h"

@implementation ChangePickupLocationViewController

@synthesize locationPicker;
@synthesize saveLocation;

NSArray<Location> *pickupLocations;
Location *newLocation;
PFUser *user;

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
    //setting this to null explicitly, before doing this, ran into an odd bug wherein the app crashed if you did the following:
    //1. fresh install
    //2. add items to cart & try place order
    //3. sign up for new account
    //4. place order
    //5. attempt to change locations
    pickupLocations = nil;
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    user = [PFUser currentUser];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [SVProgressHUD showWithStatus:@"Updating locations." maskType:SVProgressHUDMaskTypeGradient];
    
    ParseClient *parseClient = [ParseClient current];
    [parseClient POST:Locations parameters:[[NSDictionary alloc] init]
              success:^(NSURLSessionDataTask *operation, id responseObject) {
                  NSLog(@"Response object is : %@", responseObject);
                  NSError *error = nil;
                  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                  LocationResult *result = [[LocationResult alloc] initWithDictionary:responseObject error:&error];
                  pickupLocations = result.result;
                  [locationPicker reloadAllComponents];
                  
                  for (int counter = 0; counter < pickupLocations.count; counter++) {
                      Location *location = pickupLocations[counter];
                      if([location.objectId isEqualToString:[[user valueForKey:USER_LOCATION] objectId]]){
                          [locationPicker selectRow:counter inComponent:0 animated:NO];
                      }
                  }
                  
                 [SVProgressHUD dismiss];
              } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                  [SVProgressHUD dismiss];
                  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                  NSLog(@"Error in sending request to get locations %@", [error localizedDescription]);
              }
     ];

}

- (IBAction)updateLocation:(id)sender {
    user[USER_LOCATION] = [PFObject objectWithoutDataWithClassName:@"Location" objectId:newLocation.objectId];
    [SVProgressHUD showWithStatus:@"Updating location." maskType:SVProgressHUDMaskTypeGradient];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [newLocation writeToFile];
//            TabBarController *tab = (TabBarController*)self.parentViewController.parentViewController;
//            UINavigationController *menu = [tab viewControllers][1];
//            menu.tabBarItem.badgeValue = nil;
//            [[Order current] clearEntireOrder];
            [[Menu current] clearMenu];
            [[Menu current] refreshFromServerWithOverlay:TRUE];
            [self.navigationController popToRootViewControllerAnimated:FALSE];
        }
    }];
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(nil != pickupLocations){
        return [pickupLocations[row] name];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    newLocation = pickupLocations[row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (nil != pickupLocations) {
        return pickupLocations.count;
    }
    return 0;
}

- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

@end
