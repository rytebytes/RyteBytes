//
//  ParseErrorMessage.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 1/13/14.
//
//

#import "JSONModel.h"

@interface ParseErrorMessage : JSONModel
@property (nonatomic,strong) NSString<Optional> *message;
@end
