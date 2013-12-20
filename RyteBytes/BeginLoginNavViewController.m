//
//  BeginLoginNavViewController.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 12/6/13.
//
//

#import "BeginLoginNavViewController.h"
#import <Parse/Parse.h>

@interface BeginLoginNavViewController ()

@end

@implementation BeginLoginNavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = NO;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
