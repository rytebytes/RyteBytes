//
//  Text.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 3/17/14.
//
//

#import "JSONModel.h"

@interface Text : JSONModel

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *content;

@end
