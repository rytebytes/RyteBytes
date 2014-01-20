//
//  ChangeCreditCardViewController.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 11/26/13.
//
//

#import "ChangeCreditCardViewController.h"
#import "StripeCard.h"
#import "ParseClient.h"
#import "StripeCustomer.h"
#import "StripeErrorResponse.h"
#import "StripeError.h"
#import "JSONResponseSerializerWithData.h"
#import "Parse/Parse.h"
#import "Constants.h"
#import "SVProgressHUD.h"
#import "StripeCustomerResponse.h"
#import "StripeClient.h"
#import "StripeToken.h"
#import "ParseError.h"

@implementation ChangeCreditCardViewController

@synthesize lastFour;
@synthesize exp;
@synthesize cvv;
@synthesize save;

STPCard *creditCard;
NSMutableDictionary *newCard;
StripeCustomer *stripeCustomerInfo = nil;
StripeCard *customerCard;

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
    self.save.hidden = YES;
    
//    NSString *url = [[NSString alloc] initWithFormat:ExistingCustomerFormat,[[PFUser currentUser] valueForKey:STRIPE_ID]];
//    NSLog(@"Url for stripe info retrieval : %@",url);
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[[PFUser currentUser] valueForKey:@"objectId"],@"userId", nil];

    
    //make call to stripe to get the user's current CC info
    [[ParseClient current] POST:UserInfo
                     parameters:params
                        success:^(NSURLSessionDataTask *operation, id responseObject) {
                            NSError *error = nil;
                            StripeCustomerResponse *response = [[StripeCustomerResponse alloc] initWithDictionary:responseObject error:&error];
                            stripeCustomerInfo = response.result;
                            customerCard = stripeCustomerInfo.cards.data[0];
                            lastFour.text = customerCard.last4;
                            exp.text = [NSString stringWithFormat:@"%d/%d", customerCard.exp_month, customerCard.exp_year];
                            cvv.text = @"***";
                            [SVProgressHUD dismiss];
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        }
                        failure:^(NSURLSessionDataTask *operation, NSError *error) {
                            NSError *modelConversionError;
                            [SVProgressHUD dismiss];
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                            StripeError *stripeError = [[StripeErrorResponse alloc] initWithString:error.userInfo[JSONResponseSerializerWithDataKey] error:&modelConversionError].error;
                            NSLog(@"Error returned retrieving stripe info. Code:%@ . Message : %@", stripeError.code, stripeError.message);
                        }
     ];
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
    
//    NSString *url = [[NSString alloc] initWithFormat:ExistingCustomerFormat,[[PFUser currentUser] valueForKey:STRIPE_ID]];
    
    NSMutableDictionary *stripeCustomer = [[NSMutableDictionary alloc] init];
    [stripeCustomer setObject:card forKey:@"card"];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [[StripeClient current] POST:Token
                      parameters:stripeCustomer
                         success:^(NSURLSessionDataTask *operation, id responseObject) {
                             NSError *error = nil;
                             //                                    StripeCustomer *customer = [[StripeCustomer alloc] initWithDictionary:responseObject error:&error];
                             StripeToken *token = [[StripeToken alloc] initWithDictionary:responseObject error:&error];
                             NSLog(@"Successfully created stripe token: %@",responseObject);
                             [self updateCustomerWithToken:token];
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

-(void)updateCustomerWithToken:(StripeToken*)token
{
    NSString *userId = [[PFUser currentUser] valueForKey:@"objectId"];
    NSString *stripeId = [[PFUser currentUser] valueForKey:@"stripeId"];
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:userId,@"userId",stripeId,@"stripeId",token.id,@"token", nil];
    
    [[ParseClient current] POST:UpdateUser parameters:params
                        success:^(NSURLSessionDataTask *operation, id responseObject) {
                            [SVProgressHUD dismiss];
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                            UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Successfully updated credit card information" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [success show];
                            [self.navigationController popToRootViewControllerAnimated:FALSE];
                        }
                        failure:^(NSURLSessionDataTask *operation, NSError *error) {
                            NSError *modelConversionError;
                            StripeError *stripeError = [[StripeError alloc] initWithString:error.userInfo[JSONResponseSerializerWithDataKey] error:&modelConversionError];
                            NSLog(@"Error returned from updating stripe data in parse. Message : %@", stripeError.message);
                            UIAlertView *cardFailed = [[UIAlertView alloc] initWithTitle:@"Invalid credit card info." message:stripeError.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
    self.save.hidden = NO;
}

- (IBAction)scanCard:(id)sender
{
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.appToken = @"19f7f219ce8843979fa8c5f99e86d484";
    [self presentViewController:scanViewController animated:YES completion:nil];
}

@end
