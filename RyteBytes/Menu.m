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
#import "SVProgressHUD.h"

@implementation Menu

@synthesize menu;
@synthesize delegate;

NSMutableArray<LocationItem> *locationMenu;

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
    
    //when the menu object is created, attempt to load the menu stored to plist
    //if the object is nil (menu isn't available local, then create new, empty menu
    [self loadFromFile];
    if([menu count] == 0)
    {
        menu = (NSMutableArray<MenuItem>*)[[NSMutableArray alloc] initWithCapacity:100];
    }
    return self;
}

-(MenuItem*)retrieveMenuItemWithId:(NSString*)objectId
{
    for(MenuItem* item in menu){
        if([item.objectId isEqualToString:objectId])
            return item;
    }
    return nil;
}

-(BOOL)isQuantityAvailableWithMenuItemId:(NSString*)objectId withQuantity:(int)quantityOrdered
{
    if(locationMenu == nil || locationMenu.count == 0) //user isn't logged in, so always allow them to add
        return true;
    
    for(LocationItem* item in locationMenu){
        if([item.menuItemId.objectId isEqualToString:objectId])
            return (item.quantity >= quantityOrdered);
    }
    return false;
}

-(void)clearMenu
{
    [self.menu removeAllObjects];
    [locationMenu removeAllObjects];
}

/*
 This method will do something slightly different depending on whether the user is logged in.
    - If the user IS logged in, it will retrieve the menu with quantities for that item
    - If the user is NOT logged in, it will only retireve the standard menu, sans quantities
 */
-(void)refreshFromServerWithOverlay:(BOOL)showOverlay
{
    [self retrieveMenu:showOverlay];
}

-(void)retrieveMenu:(BOOL)showOverlay
{
    [self clearMenu];
    NSMutableDictionary *request = [[NSMutableDictionary alloc] init];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    ParseClient *parseClient = [ParseClient current];
    if(showOverlay){
        [SVProgressHUD showWithStatus:@"Updating menu." maskType:SVProgressHUDMaskTypeGradient];
    }
    
    PFUser *current = [PFUser currentUser];
    
    if(current){
        [request setValue:[[current valueForKey:USER_LOCATION] objectId] forKey:USER_LOCATION];
    }
    
    [parseClient POST:RetrieveMenu parameters:request
              success:^(NSURLSessionDataTask *task , id responseObject) {
                  NSError *error = nil;
                  if (current) {
                      locationMenu = (NSMutableArray<LocationItem>*)[[LocationItemResult alloc] initWithDictionary:responseObject error:&error].result;
                      [self extractMenuItemFromLocationItems:locationMenu];
                  } else {
                      menu = (NSMutableArray<MenuItem>*)[[MenuResult alloc] initWithDictionary:responseObject error:&error].result;
                  }
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
    if(locationMenu == nil || locationMenu.count == 0) //user isn't logged in, so always allow them to add
        return @"";
    
    LocationItem *item = locationMenu[0];
    return item.locationId.objectId;
}

//-(void)loadFoodPictures
//{
//    for (MenuItem *item in menu) {
//        FoodImage *img = item.foodImage;
//        [img load];
//    }
//}

-(void)extractMenuItemFromLocationItems:(NSMutableArray<LocationItem>*)locationItems
{
    for (int counter = 0; counter < locationItems.count; counter++) {
        menu[counter] = ((LocationItem*)locationItems[counter]).menuItemId;
    }
}

-(void)writeToFile
{
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath = [destPath stringByAppendingPathComponent:@"menu.plist"];
    
    // If the file doesn't exist in the Documents Folder, copy it.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:destPath]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"menu" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:destPath error:nil];
    }
    NSError *error;
    
    NSString *menuJson = [self toJSONString];
    NSData *menuData = [NSPropertyListSerialization dataWithPropertyList:menuJson format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    if(!menuData)
        NSLog(@"Unable to generate plist from menu: %@", error);
    
    BOOL success = [menuData writeToFile:destPath atomically:YES];
    if(!success)
        NSLog(@"Unable to write plist data to disk: %@", error);
    
    NSLog(@"Successfully wrote menu to disk to %@", destPath);
}

-(void)loadFromFile
{
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath = [destPath stringByAppendingPathComponent:@"menu.plist"];
    
    NSError *error;
    NSData *plistData = [NSData dataWithContentsOfFile:destPath options: 0 error: &error];
    if(!plistData)
    {
        NSLog(@"Unable to read plist data from disk: %@", error);
        return;
    }
    id plist = [NSPropertyListSerialization propertyListWithData:plistData options:0 format: NULL error: &error];
    if(!plist)
    {
        NSLog(@"Unable to decode plist from data: %@", error);
        return;
    }
    
    @try {
        menu = (NSMutableArray<MenuItem>*)[[Menu alloc] initWithString:plist error:&error].menu;
    }
    @catch (NSException *exception) {
        NSLog(@"Failed to deserialize menu, usually b/c the plist is empty: %@",exception.description);
    }
}
@end
