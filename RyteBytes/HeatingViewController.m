//
//  HeatingViewController.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 3/17/14.
//
//

#import "HeatingViewController.h"
#import "ParseClient.h"
#import "Text.h"
#import "TextResult.h"

@implementation HeatingViewController

@synthesize instructions;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ParseClient *parseClient = [ParseClient current];
    NSMutableDictionary *request = [[NSMutableDictionary alloc] init];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [request setValue:@"heating" forKey:@"name"];
    
    [parseClient POST:Content parameters:request
              success:^(NSURLSessionDataTask *task , id responseObject) {
                  NSError *error;
                  
                  Text *response = (Text*)[[TextResult alloc] initWithDictionary:responseObject error:&error].result;
                  instructions.text = response.content;
                  
                  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
              } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                  NSLog(@"Error retrieving heating instructions : %@", [error localizedDescription]);
                  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
              }
     ];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
