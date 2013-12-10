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

@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* objectId;
@property (nonatomic,strong) Pointer *charityId;
@property (nonatomic,strong) NSString* streetAddress;
@property (nonatomic,strong) NSString* city;
@property (nonatomic,strong) NSString* state;
@property (nonatomic) int zipcode;

@end
