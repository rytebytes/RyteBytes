//
//  StripeCardsResponse.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 9/13/13.
//
//

#import "JSONModel.h"
#import "StripeCard.h"

@interface StripeCardsResponse : JSONModel

@property (nonatomic,strong) NSString *object;
@property (nonatomic) int count;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSArray<StripeCard> *data;

@end
