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

@implementation IntroViewController

@synthesize locationPicker;
@synthesize getStarted;

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
}

- (long)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (nil != pickupLocations) {
        return [pickupLocations result].count;
    }
    return 0;
}

- (long)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(nil != pickupLocations){
        return [pickupLocations.result[row] name];
    }
    return @"";
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
