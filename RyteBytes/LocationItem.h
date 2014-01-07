//
//  LocationItem.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 1/6/14.
//
//

#import "JSONModel.h"
#import "Location.h"
#import "MenuItem.h"
#import "Pointer.h"

@protocol LocationItem <NSObject>
@end

@interface LocationItem : JSONModel
@property (nonatomic,strong) NSString *objectId;
@property (nonatomic,strong) Pointer<Location> *locationId;
@property (nonatomic,strong) MenuItem *menuItemId;
@property (nonatomic) int quantity;
@end
