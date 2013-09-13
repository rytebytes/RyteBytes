//
//  StripeCardToken.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 8/26/13.
//
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol StripeCard
@end

@interface StripeCard : JSONModel

@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *object;
@property (nonatomic) NSInteger exp_month;
@property (nonatomic) NSInteger exp_year;
@property (nonatomic,strong) NSString *fingerprint;
@property (nonatomic,strong) NSString *last4;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *address_city;
@property (nonatomic,strong) NSString *address_country;
@property (nonatomic,strong) NSString *address_line1;
@property (nonatomic,strong) NSString *address_line1_check;
@property (nonatomic,strong) NSString *address_line2;
@property (nonatomic,strong) NSString *address_state;
@property (nonatomic,strong) NSString *address_zip;
@property (nonatomic,strong) NSString *address_zip_check;
@property (nonatomic,strong) NSString *country;
@property (nonatomic,strong) NSString *customer;
@property (nonatomic,strong) NSString *name;

@end
