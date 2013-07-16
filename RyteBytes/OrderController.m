//
//  OrderController.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 5/11/13.
//
//

#import "OrderController.h"
#import "OrderNotifications.h"

@implementation OrderController

@synthesize order;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"registering for order notifications");
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMenuItem:) name:OrderNotification object:nil];
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

- (void) addMenuItem
{
    NSLog(@"Menu item added, notification received in order controller.");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
