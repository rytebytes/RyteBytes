//
//  MainController.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 2/4/13.
//  Copyright (c) 2013 RyteBytes Foods, Inc. All rights reserved.
//

#import "TabBarController.h"
#import "PickMealViewController.h"
#import "Dish.h"
#import "EatRyteViewController.h"

@implementation TabBarController

@synthesize currentOrder;

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

    NSLog(@"finished viewDidLoad in TabBarController");
//    UIViewController *eatRyte = [[EatRyteViewController alloc] init];
//    UIViewController *frontViewController = [[UIViewController alloc] init];
//    frontViewController.view.backgroundColor = [UIColor orangeColor];
//    PKRevealController *revealController = [PKRevealController revealControllerWithFrontViewController:frontViewController leftViewController:eatRyte];
//    revealController.delegate = self;
////    [self.revealController setLeftViewController:eatRyte];
//    self.view.window.rootViewController = revealController;
	// Do any additional setup after loading the view, typically from a nib.
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
