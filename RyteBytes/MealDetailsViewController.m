//
//  OrderController.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 4/20/13.
//
//

#import "MealDetailsViewController.h"
#import "OrderItem.h"

@implementation MealDetailsViewController

@synthesize menuItemSelected;
@synthesize foodImage;
@synthesize delegate;
@synthesize quantityStepper;
@synthesize description;
@synthesize protein;
@synthesize calories;
@synthesize carbs;
@synthesize sodium;

OrderItem *orderItem;
Order *currentOrder;

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
    //Check to see if the user has already added this item to their order
    currentOrder = [Order current];
    int currentAmountForSelectedItem = [currentOrder getSpecificItemCount:menuItemSelected.uniqueId];
    
    if(-1 != currentAmountForSelectedItem) {
        self.quantityOrdered.text = [NSString stringWithFormat:@"%d", currentAmountForSelectedItem];
        quantityStepper.value = currentAmountForSelectedItem;
        orderItem = [currentOrder getOrderItem:menuItemSelected.uniqueId];
    } else {
        self.quantityOrdered.text = @"0";
        quantityStepper.value = 0;
        orderItem = [[OrderItem alloc] initWithMenuItem:menuItemSelected withQuantity:0];
    }
    
//    for (int val = 0; val < currentAmountOrdered.doubleValue; val++) {
//        quantityStepper.value++;
//    }

    self.quantityStepper.minimumValue = 0;
    foodImage.image = [UIImage imageNamed:menuItemSelected.pictureName];
    self.description.text = menuItemSelected.longDescription;
    self.mealName.text = menuItemSelected.name;
    self.calories.text = [NSString stringWithFormat:@"%d", menuItemSelected.nutritionInfo.calories];
    self.sodium.text = [NSString stringWithFormat:@"%d", menuItemSelected.nutritionInfo.sodium];
    self.protein.text = [NSString stringWithFormat:@"%d", menuItemSelected.nutritionInfo.protein];
    self.carbs.text = [NSString stringWithFormat:@"%d", menuItemSelected.nutritionInfo.carbs];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)valueChanged:(UIStepper *)sender {
    int value = [sender value];
    
    self.quantityOrdered.text = [NSString stringWithFormat:@"%d", value];
    
    NSLog(@"Setting item : %@ to quantity of : %d", menuItemSelected.name, value);
    
    [currentOrder setOrderItemQuantity:orderItem withQuantity:value];
//    [currentOrder setMenuItemQuantity:menuItemSelected withQuantity:value];
    [self.delegate setBadgeValue:[currentOrder getTotalItemCount]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
