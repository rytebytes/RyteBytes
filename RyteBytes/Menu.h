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

-(void)refreshFromServer;
-(void)writeToFile;
-(void)loadFromFile;

-(MenuItem*)retrieveMenuItemWithId:(NSString*)objectId;

@end
