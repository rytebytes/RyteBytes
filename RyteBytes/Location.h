//
//  Location.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 11/16/13.
//
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "Pointer.h"

@protocol Location
@end

@interface Location : JSONModel

@property (nonatomic,strong) NSString* Name;
@property (nonatomic,strong) NSString* objectId;
@property (nonatomic,strong) Pointer *charityId;
@property (nonatomic,strong) NSString* StreetAddress;
@property (nonatomic,strong) NSString* City;
@property (nonatomic,strong) NSString* State;
@property (nonatomic) int Zipcode;

@end
