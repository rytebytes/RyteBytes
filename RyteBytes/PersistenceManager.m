//
//  PersistenceManager.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 3/12/14.
//
//

#import "PersistenceManager.h"

@implementation PersistenceManager

-(BOOL)saveObject:(NSString*)objectName withData:(NSData*)data
{
    NSString *fileName = [objectName stringByAppendingString:@".plist"];
    
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath = [destPath stringByAppendingPathComponent:fileName];
    
    // If the file doesn't exist in the Documents Folder, copy it.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:destPath]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:objectName ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:destPath error:nil];
    }
    NSError *error;
    
    BOOL success = [data writeToFile:destPath atomically:YES];
    if(!success){
        NSLog(@"Unable to write plist data for object %@ to disk with error: %@", objectName, error);
        return NO;
    }
    
    NSLog(@"Successfully wrote menu %@ to disk to %@", objectName, destPath);
    return YES;
}

-(id)loadObjectNamed:(NSString*)objectName
{
    NSString *fileName = [objectName stringByAppendingString:@".plist"];
    
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath = [destPath stringByAppendingPathComponent:fileName];
    
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
    
    return plist;
}

@end
