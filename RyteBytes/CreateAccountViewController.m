//
//  CreateAccountViewController.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 7/1/13.
//
//

#import "Parse/Parse.h"
#import "CreateAccountViewController.h"
#import "TabBarController.h"

@implementation CreateAccountViewController

@synthesize createAccountView;
@synthesize email;
@synthesize password;
@synthesize confirmPassword;
@synthesize headerLogo;
@synthesize addCreditCardButton;
@synthesize createAccountButton;
@synthesize pickupLocation;
@synthesize pickupOptions;

NSString *createAccountSucceedSegue = @"CreateAccountSucceed";
PFUser *currentUser;

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
    
    pickupOptions = [[NSArray alloc] initWithObjects:@"RNG",@"1871",@"Equinox", nil];
    
    // Do any additional setup after loading the view.
}

- (IBAction)createAccount:(id)sender {
    if([self validateInputs])
    {
        //sign user up
    }
    else
    {
        //display error
    }
}

- (bool)validateInputs
{
    //1. check if email is empty or doesn't contain '@'
    if([email.text length] == 0 ||
       [email.text rangeOfString:@"@"].location == NSNotFound)
        return false;
    //2. check if passwords are empty or don't match
    if([password.text length] == 0 ||
       [confirmPassword.text length] == 0 ||
       password.text != confirmPassword.text)
        return false;
    
    //3. check if credit card was entered

    return true;
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    NSLog(@"User canceled payment info");
    // Handle user cancellation here...
    [scanViewController dismissModalViewControllerAnimated:YES];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    // The full card number is available as info.cardNumber, but don't log that!
    NSLog(@"Received card info. Number: %@, expiry: %02i/%i, cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv);
    // Use the card info...
    [scanViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)scanCard:(id)sender
{
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.appToken = @"19f7f219ce8843979fa8c5f99e86d484";
    [self presentModalViewController:scanViewController animated:YES];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    return pickupOptions.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    return [pickupOptions objectAtIndex:row];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:createAccountSucceedSegue])
    {
        TabBarController *tabBar = (TabBarController *)segue.destinationViewController;
        tabBar.selectedIndex = GYM_TAB;
        tabBar.User = currentUser;
    }
}

@end
