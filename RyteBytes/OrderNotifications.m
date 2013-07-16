//
//  OrderNotifications.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 7/13/13.
//
//

#import "OrderNotifications.h"

@implementation OrderNotifications

NSString * const OrderNotification = @"OrderNotification";

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
