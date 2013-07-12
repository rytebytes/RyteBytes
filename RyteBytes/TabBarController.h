//
//  RBSecondViewController.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 2/4/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface TabBarController : UITabBarController <UITabBarControllerDelegate>

typedef enum tabs
{
    GYM_TAB = 0,
    COOKING_TAB = 1,
    ORDER_TAB = 2,
    DO_RYTE_TAB = 3,
    ACCOUNT_TAB = 4
} ScreenTabs ;

@property (nonatomic,strong) PFUser *User;

@end
