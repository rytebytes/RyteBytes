//
//  ChangeCreditCardViewController.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 11/26/13.
//
//

#import "ChangeCreditCardViewController.h"
#import "StripeCard.h"
#import "StripeClient.h"
#import "StripeCustomer.h"
#import "StripeErrorResponse.h"
#import "StripeError.h"
#import "JSONResponseSerializerWithData.h"
#import "Parse/Parse.h"
#import "Constants.h"
#import "SVProgressHUD.h"

@implementation ChangeCreditCardViewController

@synthesize stripeInfo;
@synthesize lastFour;
@synthesize exp;
@synthesize cvv;

STPCard *creditCard;
NSMutableDictionary *newCard;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = NO;
    
    StripeCard *cardInfo = stripeInfo.cards.data[0];
    lastFour.text = cardInfo.last4;
    exp.text = [NSString stringWithFormat:@"%d/%d", cardInfo.exp_month, cardInfo.exp_year];
    cvv.text = @"***";

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveNewCreditCardInfo:(id)sender
{
    NSMutableDictionary *card = [[NSMutableDictionary alloc] init];
    [card setValue:creditCard.number forKey:@"number"];
    [card setValue:[NSString stringWithFormat:@"%d", creditCard.expMonth] forKey:@"exp_month"];
    [card setValue:[NSString stringWithFormat:@"%d", creditCard.expYear] forKey:@"exp_year"];
    [card setValue:creditCard.cvc forKey:@"cvc"];
    
    NSString *url = [[NSString alloc] initWithFormat:ExistingCustomerFormat,[[PFUser currentUser] valueForKey:STRIPE_ID]];
    
    NSMutableDictionary *stripeCustomer = [[NSMutableDictionary alloc] init];
    [stripeCustomer setObject:card forKey:@"card"];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [[StripeClient current] POST:url
                      parameters:stripeCustomer
                         success:^(NSURLSessionDataTask *operation, id responseObject) {
                             NSError *error = nil;
                             StripeCustomer *customer = [[StripeCustomer alloc] initWithDictionary:responseObject error:&error];
                             stripeInfo = customer.cards.data[0];
                             [SVProgressHUD dismiss];
                             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                             UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Successfully updated credit card information" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                             [success show];
                             NSLog(@"Successfully modified credit card for customer with email %@",customer.email);
                         }
                         failure:^(NSURLSessionDataTask *operation, NSError *error) {
                             NSError *modelConversionError;
                             StripeError *stripeError = [[StripeErrorResponse alloc] initWithString:error.userInfo[JSONResponseSerializerWithDataKey] error:&modelConversionError].error;
                             NSLog(@"Error returned from stripe customer creation. Code:%@ . Message : %@", stripeError.code, stripeError.message);
                             UIAlertView *cardFailed = [[UIAlertView alloc] initWithTitle:@"Invalid credit card info." message:stripeError.message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                             [SVProgressHUD dismiss];
                             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                             [cardFailed show];
                         }];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    NSLog(@"User canceled payment info");
    // Handle user cancellation here...
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
//    [scanViewController dismissModalViewControllerAnimated:YEs];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController
{
    NSLog(@"Received card info. Number: %@, expiry: %02i/%i, cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv);
    
    creditCard = [[STPCard alloc] init];
    creditCard.number = info.cardNumber;
    creditCard.expMonth = info.expiryMonth;
    creditCard.expYear = info.expiryYear;
    creditCard.cvc = info.cvv;
    
    newCard = [[NSMutableDictionary alloc] init];
    [newCard setObject:creditCard.number forKey:@"number"];
    [newCard setObject:[NSNumber numberWithInt:creditCard.expMonth] forKey:@"exp_month"];
    [newCard setObject:[NSNumber numberWithInt:creditCard.expYear] forKey:@"exp_year"];
    [newCard setObject:creditCard.cvc forKey:@"cvc"];
    
    lastFour.text = creditCard.last4;
    exp.text = [NSString stringWithFormat:@"%d/%d", creditCard.expMonth, creditCard.expYear];
    cvv.text = creditCard.cvc;
    
    [paymentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)scanCard:(id)sender
{
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.appToken = @"19f7f219ce8843979fa8c5f99e86d484";
    [self presentViewController:scanViewController animated:YES completion:nil];
}

@end