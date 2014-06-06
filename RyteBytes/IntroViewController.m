//
//  IntroViewController.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 3/12/14.
//
//

#import "IntroViewController.h"
#import "Location.h"
#import "LocationResult.h"
#import "ParseClient.h"
#import <Parse/Parse.h>
#import "Utils.h"
#import <QuartzCore/QuartzCore.h>

@implementation IntroViewController

@synthesize locationPicker;
@synthesize getStarted;
@synthesize text;

LocationResult *pickupLocations;
Location *selectedLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    text.layer.cornerRadius = 8;
    ParseClient *parseClient = [ParseClient current];
    [parseClient POST:Locations parameters:[[NSDictionary alloc] init]
              success:^(NSURLSessionDataTask *operation, id responseObject) {
                  NSLog(@"Response object is : %@", responseObject);
                  NSError *error = nil;
                  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                  pickupLocations = [[LocationResult alloc] initWithDictionary:responseObject error:&error];
                  [locationPicker reloadAllComponents];
              } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                  NSLog(@"Error in sending request to get locations %@", [error localizedDescription]);
                  [[[UIAlertView alloc] initWithTitle:@"Network error" message:@"RyteBytes requires a network connection, please try again when you are connected to the network." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
              }
     ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//write selcted to location to disk, then dismiss the VC
- (IBAction)getStarted:(id)sender
{
    if(nil == selectedLocation)
    {
        selectedLocation = pickupLocations.result[0];
    }
    
    [selectedLocation writeToFile];

    [self dismissViewControllerAnimated:false completion:Nil];
    //send message to menu view controller to load the menu
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *name = @"";
    
    if(nil != pickupLocations){
        if ([Utils isCurrentUserAllowedToViewLocation:[pickupLocations.result[row] objectId]]) {
             name = [pickupLocations.result[row] name];
        }
    }
    return [[NSAttributedString alloc] initWithString:name attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int count = 0;
    if(nil != pickupLocations){
        for (Location *location in pickupLocations.result) {
            if([Utils isCurrentUserAllowedToViewLocation:location.objectId]) {
                count++;
            }
        }
    }
    return count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedLocation = pickupLocations.result[row];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
