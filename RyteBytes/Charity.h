//
//  Charity.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 12/16/13.
//
//

#import "JSONModel.h"

@interface Charity : JSONModel
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* objectId;
@property (nonatomic,strong) NSString* streetAddress;
@property (nonatomic,strong) NSString* city;
@property (nonatomic,strong) NSString* state;
@property (nonatomic) int zipcode;
@property (nonatomic) int totalDonationsInCents;
@property (nonatomic,strong) NSString* picture;
@property (nonatomic,strong) NSString* description;
@end
