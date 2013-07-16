//
//  OrderController.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 4/20/13.
//
//

#import <UIKit/UIKit.h>
#import "Meal.h"

@protocol MealAdded <NSObject>

- (void)addMealToOrder:(NSString *)meal withCount:(int)count;

@end

@interface MealDetailsController : UIViewController

@property (nonatomic,strong) Meal* mealToOrder;
@property (nonatomic,strong) IBOutlet UIImageView *foodImage;
@property (nonatomic,strong) IBOutlet UILabel *quantityOrdered;
@property (nonatomic,strong) IBOutlet UILabel *description;
@property (nonatomic,strong) IBOutlet UILabel *mealName;
@property (nonatomic,strong) IBOutlet UILabel *nutritionInfo;
@property (nonatomic,strong) IBOutlet UIStepper *quantityStepper;
@property (nonatomic,weak) id <MealAdded> delegate;
@property (nonatomic,strong) NSString *currentAmountOrdered;

- (IBAction)valueChanged:(UIStepper *)sender;

@end
