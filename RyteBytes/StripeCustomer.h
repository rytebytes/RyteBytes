//
//  StripeCustomer.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 8/10/13.
//
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface StripeCustomer : JSONModel

@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *object;
@property (nonatomic) BOOL livemode;
@property (nonatomic,strong) NSMutableArray *cards;
@property (nonatomic,strong) NSDate *created;
@property (nonatomic) int account_balance;
@property (nonatomic,strong) NSString *default_card;
@property (nonatomic) BOOL delinquent;
@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSDictionary *subscription;
@property (nonatomic,strong) NSDictionary *discount;

- (StripeCustomer*) initWithDictionary;

@end
