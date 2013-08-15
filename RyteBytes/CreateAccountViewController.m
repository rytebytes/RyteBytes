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
#import "AFNetworking.h"
#import "StripeClient.h"
#import "StripeCustomer.h"

@implementation CreateAccountViewController

@synthesize createAccountView;
@synthesize email;
@synthesize password;
@synthesize confirmPassword;
@synthesize headerLogo;
@synthesize addCreditCardButton;
@synthesize createAccountButton;
@synthesize tapGesture;

NSString *createAccountSucceedSegue = @"CreateAccountSucceed";
PFUser *currentUser;
NSMutableDictionary *newCard;
STPCard *creditCard;

int tagTextFieldToResign;
StripeClient* stripe;

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
    
    // Do any additional setup after loading the view.
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
   - call Stripe to create Customer object with following info:
     - email, cc info
   - extract response, check for errors
   - use uid, add it to PFUser object & send to parse
   - check response, if successful, send to eat ryte screen, else display errors
 */
- (IBAction)createAccount:(id)sender {
    NSString *message;
    if([self validateInputs:&message])
    {
        NSError *signupError;
        PFUser *newUser = [PFUser object];
        newUser.email = email.text;
        newUser.username = email.text;
        newUser.password = confirmPassword.text;
                
        NSMutableDictionary *stripeCustomer = [[NSMutableDictionary alloc] init];
        [stripeCustomer setObject:[NSNumber numberWithInt:0] forKey:@"account_balance"];
        [stripeCustomer setObject:newCard forKey:@"card"];
        [stripeCustomer setObject:email.text forKey:@"email"];
        

        //Make call to Stripe
        [[StripeClient current] postPath:CreateCustomerUrl parameters:stripeCustomer
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSError *error = nil;
                    StripeCustomer *customer = [[StripeCustomer alloc] initWithString:responseObject
                                error:&error];
                    [newUser setObject:customer.id forKey:STRIPE_ID];
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error returned from stripe customer creation. %@", error);
                }];
        

        
        if([newUser signUp:&signupError])
        {
            NSLog(@"Created new user with email : %@, password : %@, objectid : %@",newUser.email, newUser.password, newUser.objectId);
            currentUser = newUser;
           
            [self performSegueWithIdentifier:createAccountSucceedSegue sender:self];
        }
        else
        {
            UIAlertView *accountFailed = [[UIAlertView alloc] initWithTitle:@"Error creating account." message:signupError.localizedDescription delegate:NULL cancelButtonTitle:@"OK" otherButtonTitles:@"", nil];
            [accountFailed show];
        }
    }
    else {
        NSLog(@"Account creation validation failed with message : %@", [NSString stringWithString:message]);
    }
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
        return false;
    }
            
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
    
    [scanViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)scanCard:(id)sender
{
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.appToken = @"19f7f219ce8843979fa8c5f99e86d484";
    [self presentModalViewController:scanViewController animated:YES];
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
