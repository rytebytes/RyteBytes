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
#import "Constants.h"
#import "STPCard.h"
#import "Stripe.h"
#import "Constants.h"
#import "StripeClient.h"
#import "ParseClient.h"
#import "StripeCustomer.h"
#import "StripeCard.h"
#import "LocationResult.h"
#import "StripeError.h"
#import "StripeErrorResponse.h"
#import "SVProgressHUD.h"

@implementation CreateAccountViewController

@synthesize createAccountView;
@synthesize email;
@synthesize password;
@synthesize confirmPassword;
@synthesize headerLogo;
@synthesize addCreditCardButton;
@synthesize createAccountButton;
@synthesize tapGesture;
@synthesize networkActivityIndicator;
@synthesize locationPicker;

NSString *createAccountSucceedSegue = @"CreateAccountSucceed";
PFUser *user;
NSMutableDictionary *newCard;
STPCard *creditCard;
STPToken *cardToken;
LocationResult *pickupLocations;
int selectedLocationId;

int tagTextFieldToResign;

- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (nil != pickupLocations) {
        return [pickupLocations result].count;
    }
    return 0;
}

- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(nil != pickupLocations){
        return [pickupLocations.result[row] Name];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedLocationId = [pickupLocations.result[row] LocationId];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"Init with nib create account.");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tapGesture];
    user = [PFUser object];
    
    networkActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [networkActivityIndicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    ParseClient *parseClient = [ParseClient current];
    [parseClient POST:Locations parameters:[[NSDictionary alloc] init]
        success:^(NSURLSessionDataTask *operation, id responseObject) {
            NSLog(@"Response object is : %@", responseObject);
            NSError *error = nil;
            [networkActivityIndicator stopAnimating];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            pickupLocations = [[LocationResult alloc] initWithDictionary:responseObject error:&error];
            [locationPicker reloadAllComponents];
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            NSLog(@"Error in sending request to get locations %@", [error localizedDescription]);
        }
    ];
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
    
    if(textField.tag == TAG_UI_CREATEACCOUNT_EMAIL)
    {
        [[self.view viewWithTag:TAG_UI_CREATEACCOUNT_PASSWORD] becomeFirstResponder];
    }
    if(textField.tag == TAG_UI_CREATEACCOUNT_PASSWORD)
    {
        [[self.view viewWithTag:TAG_UI_CREATEACCOUNT_CONFIRM_PASSWORD] becomeFirstResponder];
    }

    return YES;
}

/* 
 Actions needed when creating account:
   - call Stripe to create card token
   - send token as part of Parse object to web service for creating RB customers in parse (web service will create new customer in stripe)
   - extract response, check for errors
   - check response, if successful, send to eat ryte screen, else display errors
 */
- (IBAction)createAccount:(id)sender {
    NSString *message;
    
    if([self validateInputs:&message])
    {
        networkActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        networkActivityIndicator.center=self.view.center;
        [networkActivityIndicator startAnimating];
        
        NSMutableDictionary *card = [[NSMutableDictionary alloc] init];
        [card setValue:creditCard.number forKey:@"number"];
        [card setValue:[NSString stringWithFormat:@"%d", creditCard.expMonth] forKey:@"exp_month"];
        [card setValue:[NSString stringWithFormat:@"%d", creditCard.expYear] forKey:@"exp_year"];
        [card setValue:creditCard.cvc forKey:@"cvc"];
        
        NSMutableDictionary *stripeCustomer = [[NSMutableDictionary alloc] init];
        [stripeCustomer setValue:email.text forKey:@"email"];
        [stripeCustomer setObject:card forKey:@"card"];
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
       
        [[StripeClient current] POST:Customers
                                parameters:stripeCustomer
                                success:^(NSURLSessionDataTask *operation, id responseObject) {
                                    NSError *error = nil;
                                    StripeCustomer *customer = [[StripeCustomer alloc] initWithDictionary:responseObject error:&error];

                                    NSLog(@"Successfully created stripe customer object with email %@",customer.email);
                                    [self createCustomer:customer];
                                }
                                failure:^(NSURLSessionDataTask *operation, NSError *error) {
                                    NSError *modelConversionError;
                                    StripeError *stripeError = [[StripeErrorResponse alloc] initWithString:error.userInfo[JSONResponseSerializerWithDataKey] error:&modelConversionError].error;
                                    NSLog(@"Error returned from stripe customer creation. Code:%@ . Message : %@", stripeError.code, stripeError.message);
                                    UIAlertView *cardFailed = [[UIAlertView alloc] initWithTitle:@"Invalid credit card info." message:stripeError.message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                    [SVProgressHUD dismiss];
                                    [cardFailed show];
                                }];
    }
    else {
        NSLog(@"Account creation validation failed with message : %@", [NSString stringWithString:message]);
        UIAlertView *validationFailed = [[UIAlertView alloc] initWithTitle:@"Invalid information." message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [validationFailed show];
    }
}

//STPCompletionBlock completionHandler = ^(STPToken *token, NSError *error)
//{
//    if (error) {
//        NSLog(@"Error trying to create token %@", [error localizedDescription]);
//        //TODO: what should happen here? Error displayed to user.
//        cardToken = NULL;
//    } else {
//        NSLog(@"Successfully created token with ID: %@", token.tokenId);
//        cardToken = token;
//        [networkActivityIndicator stopAnimating];
//        [self createCustomer];
//    }
//};
//[Stripe createTokenWithCard:creditCard completion:completionHandler];

/*
 This method is called in the success block of the create token call to Stripe.  Once we have successfully created a token from
 the user's credit card, we can proceed with the rest of the account creation.
 
 This method does the following:
 - add the stripe user id to the PFUser object for storage
 - uses Parse SDK to sign user up
 - checks for response from sign up call
 - if successful:
    - segue to starting screen
 */
- (void)createCustomer:(StripeCustomer*)stripeCustomerObject
{
    user.email = email.text;
    user.username = email.text;
    user.password = confirmPassword.text;
    [user setValue:stripeCustomerObject.id forKey:STRIPE_ID];
    [user setValue:[NSNumber numberWithInteger:selectedLocationId] forKey:USER_LOCATION_ID];

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        [SVProgressHUD dismiss];
        if(succeeded)
        {
            NSLog(@"Created new user with email : %@, password : %@, objectid : %@",user.email, user.password, user.objectId);
            [self performSegueWithIdentifier:createAccountSucceedSegue sender:self];
        }
        else
        {
            UIAlertView *accountFailed = [[UIAlertView alloc] initWithTitle:@"Error creating account." message:error.localizedDescription delegate:NULL cancelButtonTitle:@"OK" otherButtonTitles:@"", nil];
            [accountFailed show];
        }
    }];
}

- (bool)validateInputs:(NSString **)message
{
    //1. check if email is empty or doesn't contain '@'
    if([email.text length] == 0 ||
       [email.text rangeOfString:@"@"].location == NSNotFound)
    {
        *message = [[NSString alloc] initWithFormat:@"Email is invalid."];
        return false;
    }
    //2. check if passwords are empty or don't match
    if([password.text length] == 0 || [confirmPassword.text length] == 0 || ![password.text isEqualToString:confirmPassword.text])
    {
        *message = [[NSString alloc] initWithFormat:@"Passwords don't match or are empty."];
        return false;
    }
    //3. check if credit card was entered
    NSError *cardValidationError = nil;
    if(![creditCard validateCardReturningError:&cardValidationError])
    {
        *message = cardValidationError.description;
        if (0 == [*message length]) {
            *message = @"Invalid credit card information entered, please enter valid information.";
        }
        return false;
    }
    
    //4. Verify the email hasn't been taken already in Parse
    PFQuery *emailExists = [PFUser query];
    [emailExists whereKey:@"username" equalTo:email.text];
    
    NSArray *user = [emailExists findObjects];
    
    if (user.count > 0) {
        *message = @"An account has already been created with that email.  If you've forgotten your password, click on the forgot password button on the 'Sign In' screen.";
        return false;
    }

    return true;
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    NSLog(@"User canceled payment info");
    // Handle user cancellation here...
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    // The full card number is available as info.cardNumber, but don't log that!
        
    NSLog(@"Received card info. Number: %@, expiry: %02i/%i, cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv);

    creditCard = [[STPCard alloc] init];
    creditCard.number = info.cardNumber;
    creditCard.expMonth = info.expiryMonth;
    creditCard.expYear = info.expiryYear;
    creditCard.cvc = info.cvv;
    
    //validate number
    newCard = [[NSMutableDictionary alloc] init];
    [newCard setObject:creditCard.number forKey:@"number"];
    [newCard setObject:[NSNumber numberWithInt:creditCard.expMonth] forKey:@"exp_month"];
    [newCard setObject:[NSNumber numberWithInt:creditCard.expYear] forKey:@"exp_year"];
    [newCard setObject:creditCard.cvc forKey:@"cvc"];
  
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)scanCard:(id)sender
{
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.appToken = @"19f7f219ce8843979fa8c5f99e86d484";
    [self presentViewController:scanViewController animated:YES completion:nil];
//    [self presentModalViewController:scanViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:createAccountSucceedSegue])
    {
        TabBarController *tabBar = (TabBarController *)segue.destinationViewController;
        tabBar.selectedIndex = ORDER_TAB;
    }
}

@end
