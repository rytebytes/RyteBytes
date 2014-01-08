//
//  OrderController.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 4/20/13.
//
//

#import "MenuItemDetailsViewController.h"
#import "OrderItem.h"
#import "OrderSummaryViewController.h"
#import "TabBarController.h"

@implementation MenuItemDetailsViewController

@synthesize menuItemSelected;
@synthesize foodImage;
@synthesize delegate;
@synthesize detailsDelegate;
@synthesize quantityStepper;
@synthesize description;
@synthesize protein;
@synthesize calories;
@synthesize carbs;
@synthesize sodium;
@synthesize mealName;

//OrderItem *orderItem;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = NO;
    //Check to see if the user has already added this item to their order
    int currentAmountForSelectedItem = [[Order current] getSpecificItemCount:menuItemSelected.objectId];
    
    self.quantityOrdered.text = [NSString stringWithFormat:@"%d", currentAmountForSelectedItem];
    quantityStepper.value = currentAmountForSelectedItem;
    
    quantityStepper.minimumValue = 0;
    foodImage.image = [UIImage imageNamed:menuItemSelected.picture];
    description.text = menuItemSelected.longDescription;
    mealName.textAlignment = NSTextAlignmentCenter;
    mealName.textColor = [UIColor blackColor];
    
    calories.text = [NSString stringWithFormat:@"%d", menuItemSelected.nutritionInfoId.calories];
    sodium.text = [NSString stringWithFormat:@"%d", menuItemSelected.nutritionInfoId.sodium];
    protein.text = [NSString stringWithFormat:@"%d", menuItemSelected.nutritionInfoId.protein];
    carbs.text = [NSString stringWithFormat:@"%d", menuItemSelected.nutritionInfoId.carbs];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"Checkout"])
    {
        PFUser *currentUser = [PFUser currentUser];
        if (currentUser)
        {
            return YES;
        }
        else{
            TabBarController *tab = (TabBarController*)self.parentViewController.parentViewController;
            [tab showLogin];
            return NO;
        }
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Checkout"])
    {
        PFUser *currentUser = [PFUser currentUser];
        if (currentUser)
        {
            OrderSummaryViewController *orderController = segue.destinationViewController;
            [orderController setDelegate:self.delegate];
        }
    }
}

- (IBAction)valueChanged:(UIStepper *)sender {
    int value = [sender value];
    
    if(![[Order current] setMenuItem:menuItemSelected withQuantity:value]){
        sender.value--;
        [[[UIAlertView alloc] initWithTitle:@"No more left"
                                    message:[NSString stringWithFormat:@"There are no more %@ left to purchase at this location.",menuItemSelected.name]
                                   delegate:self
                          cancelButtonTitle:nil
                          otherButtonTitles:@"Okay", nil] show];
    }
    else{
        self.quantityOrdered.text = [NSString stringWithFormat:@"%d", value];
        NSLog(@"Setting item : %@ to quantity of : %d", menuItemSelected.name, value);
        [self.delegate setBadgeValue:[[Order current] getTotalItemCount]];
    }
}

@end
