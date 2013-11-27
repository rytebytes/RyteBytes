//
//  ChangeCreditCardViewController.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 11/26/13.
//
//

#import <UIKit/UIKit.h>
#import "StripeCustomer.h"
#import "CardIO.h"

@interface ChangeCreditCardViewController : UIViewController<CardIOPaymentViewControllerDelegate,UITextFieldDelegate>

@property (nonatomic,strong) StripeCustomer *stripeInfo;
@property (nonatomic,strong) IBOutlet UITextField *cvv;
@property (nonatomic,strong) IBOutlet UITextField *lastFour;
@property (nonatomic,strong) IBOutlet UITextField *exp;
@property (nonatomic,strong) IBOutlet UIButton *save;

@end
