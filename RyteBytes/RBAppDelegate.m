//
//  RBAppDelegate.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 2/4/13.
//  Copyright (c) 2013 RyteBytes Foods, Inc. All rights reserved.
//

#import "RBAppDelegate.h"
#import "PickMealViewController.h"
#import "Dish.h"
#import "TabBarController.h"
#import "EatRyteViewController.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "Stripe.h"


@implementation RBAppDelegate

@synthesize window = _window;
@synthesize objectContext;

NSMutableArray *components;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //set default page for tabs to middle tab
    
    [Parse setApplicationId:@"zaZmkcjbGLCrEHagb8uJPt5TKyiFgCg9WffA6c6M"
                  clientKey:@"DltIu9MSxC9k1ly58gpdpXMkGlPI6KkfSeTkjwYa"];

    [Stripe setDefaultPublishableKey:@"pk_test_pDS0kwh6BQ2pLv7sadAQcrPr"];
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
//
//    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    return YES;
}

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
