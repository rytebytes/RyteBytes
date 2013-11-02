//
//  RBSecondViewController.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 2/4/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Order.h"

@interface TabBarController : UITabBarController <UITabBarControllerDelegate>

typedef enum tabs
{
    COOKING_TAB = 0,
    ORDER_TAB = 1,
    DO_RYTE_TAB = 2,
    ACCOUNT_TAB = 3
} ScreenTabs ;

@property (nonatomic,strong) PFUser *User;
@property (nonatomic,strong) Order *currentOrder;

@end
