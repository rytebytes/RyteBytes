//
//  ChangeCreditCardViewController.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 11/26/13.
//
//

#import "ChangeCreditCardViewController.h"
#import "StripeCard.h"

@implementation ChangeCreditCardViewController

@synthesize stripeInfo;
@synthesize lastFour;
@synthesize exp;
@synthesize cvv;

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
    
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    NSLog(@"User canceled payment info");
    // Handle user cancellation here...
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
//    [scanViewController dismissModalViewControllerAnimated:YEs];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController
{
    
}

- (IBAction)scanCard:(id)sender
{
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.appToken = @"19f7f219ce8843979fa8c5f99e86d484";
    [self presentViewController:scanViewController animated:YES completion:nil];
}

@end
