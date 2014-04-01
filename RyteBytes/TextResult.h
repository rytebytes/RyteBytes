//
//  TextResult.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 3/17/14.
//
//

#import "JSONModel.h"
#import "Text.h"

@interface TextResult : JSONModel
@property (nonatomic,strong) Text *result;
@end
