//
//  PersistenceManager.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 3/12/14.
//
//

#import <Foundation/Foundation.h>

@interface PersistenceManager : NSObject

-(BOOL)saveObject:(NSString*)objectName withData:(NSData*)data;
-(id)loadObjectNamed:(NSString*)objectName;

@end
