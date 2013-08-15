//
//  OrderController.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 4/20/13.
//
//

#import "MealDetailsViewController.h"

@implementation MealDetailsViewController

@synthesize mealToOrder;
@synthesize foodImage;
@synthesize nutritionInfo;
@synthesize delegate;
@synthesize currentAmountOrdered;
@synthesize quantityStepper;
@synthesize description;

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
    foodImage.image = [UIImage imageNamed:mealToOrder.imageName];
    self.quantityOrdered.text = currentAmountOrdered;
    quantityStepper.value = 0;
    self.quantityStepper.minimumValue = 0;
    
    for (int val = 0; val < currentAmountOrdered.doubleValue; val++) {
        quantityStepper.value++;
    }

    self.description.text = mealToOrder.description;
    self.mealName.text = mealToOrder.name;
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
    
    [self.delegate addMealToOrder:mealToOrder.name withCount:(int)value];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
