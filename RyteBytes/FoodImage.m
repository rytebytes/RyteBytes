//
//  FoodImage.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 4/27/13.
//
//

#import "FoodImage.h"
#import "CloudinaryClient.h"

@implementation FoodImage

+(UIImage*)loadWithImageName:(NSString*)imageName
{
    NSString *bundleImgPath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:bundleImgPath]) { //was included with app when installed
        NSError *error;
        NSData *plistData = [NSData dataWithContentsOfFile:bundleImgPath options: 0 error: &error];
        if(!plistData)
        {
            NSLog(@"Unable to read plist data from disk: %@", error);
            return nil;
        }
        return [UIImage imageWithData:plistData];
    } else { //image not found locall, retrieve from server & write to disk
        return nil;
    }
}

@end
