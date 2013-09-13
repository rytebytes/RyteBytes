//
//  StripeCustomer.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 8/10/13.
//
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "STPCard.h"
#import "StripeCard.h"
#import "StripeCardsResponse.h"

@interface StripeCustomer : JSONModel

@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *object;
@property (nonatomic) BOOL livemode;
@property (nonatomic,strong) StripeCardsResponse *cards;
@property (nonatomic) long created;
@property (nonatomic) int account_balance;
@property (nonatomic,strong) NSString *default_card;
@property (nonatomic) BOOL delinquent;
@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSDictionary *subscription;
@property (nonatomic,strong) NSDictionary *discount;

-(StripeCustomer*) initWithCard:(STPCard*)creditCard;

@end
