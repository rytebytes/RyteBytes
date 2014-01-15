//
//  ParseError.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 1/13/14.
//
//

#import "JSONModel.h"

@interface ParseError : JSONModel

@property (nonatomic,strong) NSString<Optional> *code;
@property (nonatomic,strong) NSString<Optional> *error;

-(NSString*)extractMessage;

@end
