//
//  Location.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 11/16/13.
//
//

#import "Location.h"
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
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath = [destPath stringByAppendingPathComponent:@"location.plist"];
    
    // If the file doesn't exist in the Documents Folder, copy it.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:destPath]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"location" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:destPath error:nil];
    }

    NSError *error;
    NSString *locationJson = [self toJSONString];
    NSData *locationData = [NSPropertyListSerialization dataWithPropertyList:locationJson format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    if(!locationData)
        NSLog(@"Unable to generate plist from menu: %@", error);
    
    BOOL success = [locationData writeToFile:destPath options:NSDataWritingAtomic error:&error];
    if(!success)
        NSLog(@"Unable to write plist data to disk: %@", error);
    else
        NSLog(@"Wrote location to disk : %@", self.name);
    
}

-(id)initFromFile
{
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath = [destPath stringByAppendingPathComponent:@"location.plist"];
    
    NSError *error;
    NSData *plistData = [NSData dataWithContentsOfFile:destPath options: 0 error: &error];
    if(!plistData)
    {
        NSLog(@"Unable to read plist data from disk: %@", error);
        return nil;
    }
    id plist = [NSPropertyListSerialization propertyListWithData:plistData options:0 format: NULL error: &error];
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
    }
}

@end
