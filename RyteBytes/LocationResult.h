//
//  LocationResult.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 11/16/13.
//
//

#import "JSONModel.h"
#import "Location.h"

@interface LocationResult : JSONModel
@property (nonatomic,strong) NSArray<Location> *result;
@end
