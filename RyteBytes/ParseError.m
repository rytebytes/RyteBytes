//
//  ParseError.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 1/13/14.
//
//

#import "ParseError.h"
#import "LocationItem.h"
#import "Menu.h"

@implementation ParseError

-(NSString*)extractMessage {
    //{"code":141,"error":"<JO2eEQaQAS> is currently sold out! Try again soon!"}
    
    if([self.error rangeOfString:@"<"].location == NSNotFound){
        return self.error;
    } else {
        NSString* msg = [self.error componentsSeparatedByString:@">"][0];
        msg = [msg componentsSeparatedByString:@"<"][1];
        LocationItem *item = [[Menu current] retrieveItemWithId:msg];
        NSString *idPlaceholder = [NSString stringWithFormat:@"<%@>",msg];
        return [self.error stringByReplacingOccurrencesOfString:idPlaceholder withString:item.menuItemId.name];
    }
}

@end
