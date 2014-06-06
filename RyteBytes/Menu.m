//
//  Menu.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 12/11/13.
//
//

#import "Menu.h"
#import "Order.h"
#import "ParseClient.h"
#import "MenuResult.h"
#import <Parse/Parse.h>
#import "LocationItem.h"
#import "LocationItemResult.h"
#import "Location.h"
#import "SVProgressHUD.h"
#import "PersistenceManager.h"

@implementation Menu

@synthesize menu;
@synthesize delegate;

+(Menu*)current
{
    static Menu *currentMenu;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentMenu = [[self alloc] init];
    });
    return currentMenu;
}

-(id)init
{
    if(!(self = [super init]))
        return nil;

    NSLog(@"Current menu being initialized.");
    
    menu = (NSMutableArray<LocationItem>*)[[NSMutableArray alloc] initWithCapacity:100];
    
    return self;
}

-(BOOL)isEmpty
{
    if ([self.menu count] == 0) {
        return TRUE;
    }
    return FALSE;
}

-(LocationItem*)retrieveItemWithId:(NSString*)objectId
{
    for(LocationItem* item in menu){
        if([item.objectId isEqualToString:objectId])
            return item;
    }
    return nil;
}

-(LocationItem*)retrieveLocationItemWithMenuItemId:(NSString*)menuItemId
{
    for(LocationItem* item in menu){
        if([item.menuItemId.objectId isEqualToString:menuItemId])
            return item;
    }
    return nil;
}

-(BOOL)isQuantityAvailable:(NSString*)menuItemId withQuantity:(int)quantityOrdered
{
    for(LocationItem* item in menu){
        if([item.menuItemId.objectId isEqualToString:menuItemId])
            return (item.quantity >= quantityOrdered);
    }
    return false;
}

-(void)refreshFromServerWithOverlay:(BOOL)showOverlay
{
    [self retrieveMenu:showOverlay];
}

-(void)retrieveMenu:(BOOL)showOverlay
{
    [menu removeAllObjects];
    NSMutableDictionary *request = [[NSMutableDictionary alloc] init];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    ParseClient *parseClient = [ParseClient current];
    if(showOverlay){
        [SVProgressHUD showWithStatus:@"Updating menu." maskType:SVProgressHUDMaskTypeGradient];
    }
    
    PFUser *current = [PFUser currentUser];
    
    if(current){
        [request setValue:[[current valueForKey:USER_LOCATION] objectId] forKey:USER_LOCATION];
    } else{
        //retrieve location that user selected on intro screen
        [request setValue:[[Location alloc] initFromFile].objectId forKeyPath:USER_LOCATION];
    }
    
    [parseClient POST:RetrieveMenu parameters:request
              success:^(NSURLSessionDataTask *task , id responseObject) {
                  NSError *error = nil;

                  menu = (NSMutableArray<LocationItem>*)
                        [[LocationItemResult alloc] initWithDictionary:responseObject error:&error].result;

                  [self writeToFile];
                  if(showOverlay){
                      [SVProgressHUD dismiss];
                  }
                  
                  if(self.delegate != nil)
                      [delegate refreshFromServerCompleteWithSuccess:TRUE];
                  
                  if([Order current].delegate != nil)
                      [[Order current].delegate orderUpdatedWithNewMenu];
                  
                  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
              } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                  NSLog(@"Error returned retrieving menu %@", [error localizedDescription]);
                  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                  if(showOverlay){
                      [SVProgressHUD dismiss];
                  }
                  [self loadFromFile]; //if we can't reach the network/server, load local copy
                  [delegate refreshFromServerCompleteWithSuccess:FALSE];
                  [[[UIAlertView alloc] initWithTitle:@"Error connecting."
                                              message:@"There was an error connecting to our servers - please try again."
                                             delegate:nil
                                    cancelButtonTitle:@"Okay"
                                    otherButtonTitles:nil] show];
                  
              }
     ];
}

-(NSString*)getLocationId
{
    LocationItem *item = menu[0];
    return item.locationId.objectId;
}

-(void)writeToFile
{
    NSError *error;
    NSString *menuJson = [self toJSONString];
    NSData *menuData = [NSPropertyListSerialization dataWithPropertyList:menuJson format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    if(!menuData)
        NSLog(@"Unable to generate plist from menu: %@", error);
    
    [[[PersistenceManager alloc] init] saveObject:@"menu" withData:menuData];
}

-(void)loadFromFile
{
    NSError *error;
    id plist = [[[PersistenceManager alloc] init] loadObjectNamed:@"menu"];
    if(!plist)
    {
        NSLog(@"Unable to decode plist from data: %@", error);
        return;
    }
    
    @try {
        Menu *menuFromDisk = [[Menu alloc] initWithString:plist error:&error];
        self.menu = menuFromDisk.menu;
    }
    @catch (NSException *exception) {
        NSLog(@"Failed to deserialize menu, usually b/c the plist is empty: %@",exception.description);
    }
}
@end
