//
//  Menu.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 12/11/13.
//
//

#import "JSONModel.h"
#import "LocationItem.h"

@protocol MenuRefresh <NSObject>
- (void)refreshFromServerCompleteWithSuccess:(BOOL)success;
@end

@interface Menu : JSONModel

@property (strong,nonatomic) NSMutableArray<LocationItem> *menu;
@property (nonatomic,weak) id<MenuRefresh,Ignore> delegate;

+ (Menu*)current;

-(void)refreshFromServerWithOverlay:(BOOL)showOverlay;
-(void)writeToFile;
-(void)loadFromFile;

-(LocationItem*)retrieveItemWithId:(NSString*)objectId;
-(BOOL)isQuantityAvailable:(NSString*)menuItemId withQuantity:(int)quantityOrdered;
-(NSString*)getLocationId;

@end
