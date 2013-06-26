//
//  OrderController.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 5/11/13.
//
//

#import "OrderController.h"

@implementation OrderController

@synthesize order;

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
	// Do any additional setup after loading the view.
    
    NSEnumerator *keys = order.keyEnumerator;
    id object;
    
    while ((object = [keys nextObject])) {
        
    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
