//
//  Menu.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 12/11/13.
//
//

#import "Menu.h"
#import "ParseClient.h"
#import "MenuResult.h"

@implementation Menu

@synthesize menu;
@synthesize delegate;

-(id)init
{
    if(!(self = [super init]))
        return nil;
    
    NSLog(@"Current order being initialized.");
    menu = (NSMutableArray<MenuItem>*)[[NSMutableArray alloc] initWithCapacity:100];
    
    return self;
}

-(void)refreshFromServer
{
    ParseClient *parseClient = [ParseClient current];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [parseClient POST:RetrieveMenu parameters:[[NSDictionary alloc] init]
              success:^(NSURLSessionDataTask *task , id responseObject) {
                  NSError *error = nil;
                  menu = (NSMutableArray<MenuItem>*)[[MenuResult alloc] initWithDictionary:responseObject error:&error].result;
                  [delegate refreshFromServerCompleteWithSuccess:TRUE];
                  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                  

              } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                  NSLog(@"Error returned retrieving menu %@", [error localizedDescription]);
                  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                  [delegate refreshFromServerCompleteWithSuccess:FALSE];
                  [[[UIAlertView alloc] initWithTitle:@"Error connecting."
                                              message:@"There was an error connecting to our servers - please try again."
                                             delegate:nil
                                    cancelButtonTitle:@"Okay"
                                    otherButtonTitles:nil] show];
                  
              }
     ];
}

-(void)writeToFile
{
//    NSString *menuPath = [[NSBundle mainBundle] pathForResource:@"menu" ofType:@"plist"];
//    
//    NSString *menu = [[Order current] serializeToString];
//    NSData *menuData = [NSPropertyListSerialization dataWithPropertyList:[[Order current] serializeToString] format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
//    if(!menuData)
//        NSLog(@"Unable to generate plist from Airplane: %@", error);
//    BOOL success = [menuData writeToFile:menuPath atomically:YES];
//    if(!success)
//        NSLog(@"Unable to write plist data to disk: %@", error);
//    
//    NSData *plistData = [NSData dataWithContentsOfFile:menuPath options: 0 error: &error];
//    if(!plistData)
//    {
//        NSLog(@"Unable to read plist data from disk: %@", error);
//        return;
//    }
//    id plist = [NSPropertyListSerialization propertyListWithData: plistData options:0 format: NULL error: &error];
//    if(!plist)
//    {
//        NSLog(@"Unable to decode plist from data: %@", error);
//        return;
//    }
//    
//    menuItems = nil;
//    menuItems = [Order current] in
    
    //              NSLog(@"file Stored at %@",menuPath);
    //
    //              menuItems = nil;
    //
    //              menuItems = [NSArray arrayWithContentsOfFile:menuPath];
    //              NSLog(@"%@",menuItems);
}

-(void)loadFromFile
{
    
}


@end
