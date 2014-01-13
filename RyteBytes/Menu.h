//
//  Menu.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 12/11/13.
//
//

#import "JSONModel.h"
#import "MenuItem.h"
@protocol MenuRefresh <NSObject>
- (void)refreshFromServerCompleteWithSuccess:(BOOL)success;
@end

@interface Menu : JSONModel

@property (strong,nonatomic) NSMutableArray<MenuItem> *menu;
@property (nonatomic,weak) id<MenuRefresh,Ignore> delegate;

+ (Menu*)current;

-(void)refreshFromServerWithOverlay:(BOOL)showOverlay;
-(void)writeToFile;
-(void)loadFromFile;
-(void)clearMenu;

-(MenuItem*)retrieveMenuItemWithId:(NSString*)objectId;
-(BOOL)isQuantityAvailableWithMenuItemId:(NSString*)objectId withQuantity:(int)quantityOrdered;

@end