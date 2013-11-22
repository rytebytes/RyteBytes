//
//  JSONResponseSerializerWithData.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 11/22/13.
//
//

#import "AFURLResponseSerialization.h"
#import "AFURLResponseSerialization.h"

/// NSError userInfo key that will contain response data
static NSString * const JSONResponseSerializerWithDataKey = @"JSONResponseSerializerWithDataKey";

@interface JSONResponseSerializerWithData : AFJSONResponseSerializer

@end
