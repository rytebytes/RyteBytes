//
//  LocationItemResult.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 1/6/14.
//
//

#import "JSONModel.h"
#import "LocationItem.h"

@interface LocationItemResult : JSONModel
@property (nonatomic,strong) NSArray<LocationItem> *result;
@end
