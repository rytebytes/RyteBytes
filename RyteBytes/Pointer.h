//
//  Pointer.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 11/26/13.
//
//

#import "JSONModel.h"

@protocol Pointer
@end

@interface Pointer : JSONModel

@property (nonatomic,strong) NSString *__type;
@property (nonatomic,strong) NSString *className;
@property (nonatomic,strong) NSString *objectId;

@end
