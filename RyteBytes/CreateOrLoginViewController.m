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
    NSLog(@"in view will appear for create or login vc.");
    if([PFUser currentUser])
    {
        [self.delegate dismiss];
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
