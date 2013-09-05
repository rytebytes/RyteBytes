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
#import "StripeCardToken.h"

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

NSString *createAccountSucceedSegue = @"CreateAccountSucceed";
PFUser *user;
NSMutableDictionary *newCard;
STPCard *creditCard;
STPToken *cardToken;

int tagTextFieldToResign;

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
//        [self.view addSubview:activityView];
        
        STPCompletionBlock completionHandler = ^(STPToken *token, NSError *error)
        {
            if (error) {
                NSLog(@"Error trying to create token %@", [error localizedDescription]);
                //TODO: what should happen here? Error displayed to user.
                cardToken = NULL;
            } else {
                NSLog(@"Successfully created token with ID: %@", token.tokenId);
                cardToken = token;
                [networkActivityIndicator stopAnimating];
                [self createCustomer];
            }
        };
        
        [Stripe createTokenWithCard:creditCard completion:completionHandler];
    }
    else {
        NSLog(@"Account creation validation failed with message : %@", [NSString stringWithString:message]);
    }
}


//Make call to Stripe
//        [[StripeClient current] postPath:CreateCustomerUrl parameters:stripeCustomer
//                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                     NSError *error = nil;
//                                     StripeCustomer *customer = [[StripeCustomer alloc] initWithString:responseObject error:&error];
//                                     [user setObject:customer.id forKey:STRIPE_ID];
//                                 }
//                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                     NSLog(@"Error returned from stripe customer creation. %@", error);
//                                 }];

/*
 This method is called in the success block of the create token call to Stripe.  Once we have successfully created a token from
 the user's credit card, we can proceed with the rest of the account creation.
 
 This method does the following:
 - uses Parse SDK to sign user up
 - checks for response from sign up call
 - if successful:
    - create a stripe customer object that includes email & credit card token
    - send stripe customer object to our custom web service that will in turn make a call to stripe to create a customer object in stripe
    - add the stripe customer id to the parse user table
        - TODO: if this fails, need to alert app - maybe a notification?
    - segue to starting screen
 */
- (void)createCustomer
{
    user.email = email.text;
    user.username = email.text;
    user.password = confirmPassword.text;

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if(succeeded)
        {
            NSLog(@"Created new user with email : %@, password : %@, objectid : %@",user.email, user.password, user.objectId);
            
            ParseClient *parseClient = [ParseClient current];
            StripeCustomer *stripeCustomer = [[StripeCustomer alloc] init];
            
            stripeCustomer.email = user.email;
            stripeCustomer.default_card = cardToken.tokenId;
            stripeCustomer.id = user.objectId;
            
            [parseClient postPath:CreateUser parameters:[stripeCustomer toDictionary]
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"Success in sending request to createuser (request url: %@).", [[[operation request] URL] absoluteString]);
                    NSLog(@"Response object is : %@", responseObject);
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error in sending request to createuser %@ (request url: %@)", [error localizedDescription],[[[operation request] URL] absoluteString]);
                }
            ];
            
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
        tabBar.selectedIndex = ORDER_TAB;
        tabBar.User = [PFUser currentUser];
    }
}

@end
