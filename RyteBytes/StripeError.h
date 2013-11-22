//
//  StripeError.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 11/22/13.
//
//

#import "JSONModel.h"

@interface StripeError : JSONModel

@property (nonatomic,strong) NSString* message;
@property (nonatomic,strong) NSString* type;
@property (nonatomic,strong) NSString<Optional>* code;
@property (nonatomic,strong) NSString<Optional>* param;

@end
