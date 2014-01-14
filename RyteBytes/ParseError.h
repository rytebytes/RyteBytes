//
//  ParseError.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 1/13/14.
//
//

#import "JSONModel.h"
#import "ParseErrorMessage.h"

@interface ParseError : JSONModel

@property (nonatomic,strong) NSString<Optional> *code;
@property (nonatomic,strong) NSString<Optional> *error;
//@property (nonatomic,strong) ParseErrorMessage<Optional> *error;

@end
