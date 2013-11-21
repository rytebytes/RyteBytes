//
//  CreateAccountViewController.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 7/1/13.
//
//

#import <Parse/Parse.h>
#import "CardIO.h"
#import "StripeCustomer.h"

@interface CreateAccountViewController : UIViewController <CardIOPaymentViewControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic,strong) IBOutlet UIView *createAccountView;
@property (nonatomic,strong) IBOutlet UITextField *email;
@property (nonatomic,strong) IBOutlet UITextField *password;
@property (nonatomic,strong) IBOutlet UITextField *confirmPassword;
@property (nonatomic,strong) IBOutlet UIImageView *headerLogo;
@property (nonatomic,strong) IBOutlet UIButton *addCreditCardButton;
@property (nonatomic,strong) IBOutlet UIButton *createAccountButton;
@property (nonatomic,strong) IBOutlet UITapGestureRecognizer *tapGesture;
@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *networkActivityIndicator;
@property (nonatomic,strong) IBOutlet UIPickerView *locationPicker;

//-(void)registerStripeCustomer;
-(void)createCustomer:(StripeCustomer*)stripeCustomerObject;

@end
