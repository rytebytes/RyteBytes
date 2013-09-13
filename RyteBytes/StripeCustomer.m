//
//  StripeCustomer.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 8/10/13.
//
//

#import "StripeCustomer.h"


@implementation StripeCustomer

@synthesize email;

- (StripeCustomer*) initWithCard:(STPCard*)creditCard
{
    if(!(self = [super init]))
        return nil;
    
    NSMutableDictionary *card = [[NSMutableDictionary alloc] init];
    [card setValue:creditCard.number forKey:@"number"];
    [card setValue:[NSString stringWithFormat:@"%d", creditCard.expMonth] forKey:@"exp_month"];
    [card setValue:[NSString stringWithFormat:@"%d", creditCard.expYear] forKey:@"exp_year"];
    [card setValue:creditCard.cvc forKey:@"cvc"];
    
    return self;
}

@end
