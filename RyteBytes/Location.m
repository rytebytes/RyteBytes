//
//  Location.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 11/16/13.
//
//

#import "Location.h"
#import "PersistenceManager.h"
#import <Parse/Parse.h>
#import "Constants.h"

@implementation Location

NSString *locationPath;

-(id)init{
    
    if(!(self = [super init]))
        return nil;
    
    locationPath = [[NSBundle mainBundle] pathForResource:@"location" ofType:@"plist"];
    
    return self;
}

-(void)writeToFile
{
    
    NSError *error;
    NSString *locationJson = [self toJSONString];
    NSData *locationData = [NSPropertyListSerialization dataWithPropertyList:locationJson format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    if(!locationData)
        NSLog(@"Unable to generate plist from menu: %@", error);
    

    [[[PersistenceManager alloc] init] saveObject:@"location" withData:locationData];
}

-(id)initFromFile
{
    NSError *error;

    id plist = [[[PersistenceManager alloc] init] loadObjectNamed:@"location"];
    if(!plist)
    {
        NSLog(@"Unable to decode plist from data: %@", error);
        return nil;
    }
    
    @try {
        return (Location*)[[Location alloc] initWithString:plist error:&error];
    }
    @catch (NSException *exception) {
        NSLog(@"Failed to deserialize location, usually b/c the plist is empty: %@",exception.description);
        return Nil;
    }
}

@end
