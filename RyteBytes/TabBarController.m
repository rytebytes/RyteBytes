//
//  MainController.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 2/4/13.
//  Copyright (c) 2013 RyteBytes Foods, Inc. All rights reserved.
//

#import "TabBarController.h"
#import "MenuViewController.h"
#import "Dish.h"
#import "EatRyteViewController.h"
#import "BeginLoginNavViewController.h"

@implementation TabBarController

@synthesize currentOrder;

BeginLoginNavViewController *loginNav;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    currentOrder = [Order current];
    
    self.selectedIndex = ORDER_TAB;

    NSLog(@"finished viewDidLoad in TabBarController");
}

- (void)showLogin
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    loginNav = (BeginLoginNavViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SignIn"];
    loginNav.delegate = self;
    [self presentViewController:loginNav animated:true completion:Nil];
}

- (void)dismiss
{
    [loginNav dismissViewControllerAnimated:TRUE completion:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
