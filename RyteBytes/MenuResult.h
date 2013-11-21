//
//  MenuResult.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 11/20/13.
//
//

#import "JSONModel.h"
#import "MenuItem.h"

@interface MenuResult : JSONModel
@property (nonatomic,strong) NSArray<MenuItem> *result;
@end
