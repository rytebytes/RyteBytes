//
//  RBFirstViewController.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 2/4/13.
//  Copyright (c) 2013 RyteBytes Foods, Inc. All rights reserved.
//

#import "EatRyteController.h"
#import "PickMealController.h"

@implementation EatRyteController

@synthesize pickMealBtn;
@synthesize buildMealBtn;
@synthesize checkOutBtn;
@synthesize heading;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [heading setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"eatRyteCheckout"])
    {
        NSLog(@"Send order to checkout controller");
    }
}



@end
