//
//  OrderController.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 4/20/13.
//
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "MenuItemDetailsViewController.h"
#import "OrderItem.h"
#import "OrderSummaryViewController.h"
#import "TabBarController.h"

@implementation MenuItemDetailsViewController

@synthesize locationItemSelected;
@synthesize foodImageView;
@synthesize delegate;
@synthesize quantityStepper;
@synthesize description;
@synthesize protein;
@synthesize calories;
@synthesize carbs;
@synthesize sodium;
@synthesize mealName;
@synthesize price;

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
    int currentAmountForSelectedItem = [[Order current] getSpecificItemCount:locationItemSelected.objectId];
    
    self.quantityOrdered.text = [NSString stringWithFormat:@"%d", currentAmountForSelectedItem];
    quantityStepper.value = currentAmountForSelectedItem;
    
    quantityStepper.minimumValue = 0;
   [foodImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:CLOUDINARY_IMAGE_FOOD_URL,locationItemSelected.menuItemId.picture]]];
    
    description.text = locationItemSelected.menuItemId.longDescription;
    mealName.textAlignment = NSTextAlignmentCenter;
    mealName.textColor = [UIColor blackColor];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSNumber *cost = [NSNumber numberWithFloat:locationItemSelected.costInCents / 100.0];
    price.text = [formatter stringFromNumber:cost];
    
    calories.text = [NSString stringWithFormat:@"%ld", locationItemSelected.menuItemId.nutritionInfoId.calories];
    sodium.text = [NSString stringWithFormat:@"%ld", locationItemSelected.menuItemId.nutritionInfoId.sodium];
    protein.text = [NSString stringWithFormat:@"%ld", locationItemSelected.menuItemId.nutritionInfoId.protein];
    carbs.text = [NSString stringWithFormat:@"%ld", locationItemSelected.menuItemId.nutritionInfoId.carbs];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Checkout"])
    {
        OrderSummaryViewController *orderController = segue.destinationViewController;
        [orderController setDelegate:self.delegate];
    }
}

- (IBAction)valueChanged:(UIStepper *)sender {
    int value = [sender value];
    
    if(![[Order current] setLocationItem:locationItemSelected withQuantity:value]){
        sender.value--;
        [[[UIAlertView alloc] initWithTitle:@"No more left"
                                    message:[NSString stringWithFormat:@"There are no more %@ left to purchase at this location.",locationItemSelected.menuItemId.name]
                                   delegate:self
                          cancelButtonTitle:nil
                          otherButtonTitles:@"Okay", nil] show];
    }
    else{
        self.quantityOrdered.text = [NSString stringWithFormat:@"%d", value];
        NSLog(@"Setting item : %@ to quantity of : %d", locationItemSelected.menuItemId.name, value);
        [self.delegate setBadgeValue:[[Order current] getTotalItemCount]];
    }
}

@end
