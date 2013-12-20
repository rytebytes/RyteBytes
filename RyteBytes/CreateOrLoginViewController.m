//
//  LoginController.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 6/22/13.
//
//

#import "CreateOrLoginViewController.h"
#import "CreateAccountViewController.h"
#import "TabBarController.h"

@implementation CreateOrLoginViewController
@synthesize backBtn;
//executed every time the screen appears
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

//only called when it's loaded, not viewed
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = NO;
}

//called before loading the actual view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([PFUser currentUser])
    {
        [self.navigationController dismissViewControllerAnimated:TRUE completion:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}
- (IBAction)cancelSignUpLogin:(id)sender
{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)successFromViewController:(UIViewController*)controller
{
    [controller dismissViewControllerAnimated:false completion:nil];
    [self dismissViewControllerAnimated:false completion:nil];
}

@end
