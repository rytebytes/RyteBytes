//
//  StripeToken.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 1/18/14.
//
//

#import "JSONModel.h"
#import "StripeCard.h"

@interface StripeToken : JSONModel

@property (nonatomic,strong) StripeCard *card;
@property (nonatomic,strong) NSString *id;

@end
