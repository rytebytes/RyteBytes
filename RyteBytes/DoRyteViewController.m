//
//  DoRyteViewController.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 11/25/13.
//
//

#import "DoRyteViewController.h"
#import "Location.h"
#import <Parse/Parse.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Constants.h"

@implementation DoRyteViewController

@synthesize charityContributionTotal;
@synthesize charityLogo;
@synthesize charityName;
@synthesize noUserMessage;
@synthesize charityContributionTotalLabel;
@synthesize charityDescription;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    PFUser *current = [PFUser currentUser];
    
    if(!current) {
        noUserMessage.hidden = FALSE;
        charityContributionTotal.hidden = TRUE;
        charityLogo.hidden = TRUE;
        charityName.hidden = TRUE;
        charityContributionTotalLabel.hidden = TRUE;
        charityDescription.hidden = TRUE;
    }
    else {
        
        noUserMessage.hidden = TRUE;
        charityContributionTotal.hidden = FALSE;
        charityLogo.hidden = FALSE;
        charityName.hidden = FALSE;
        charityContributionTotalLabel.hidden = FALSE;
        charityDescription.hidden = FALSE;
        
        Location *currentLocation = [[Location alloc] initFromFile];
        charityName.text = currentLocation.charityId.name;
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[currentLocation.charityId.picture stringByDeletingPathExtension] ofType:@"jpg"];
        
        if(nil != filePath){ //image found with app bundle, load into SD image cache for rest of app lifetime
            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
            [[SDImageCache sharedImageCache] storeImage:image forKey:[NSString stringWithFormat:CLOUDINARY_IMAGE_URL,currentLocation.charityId.picture]];
        }
        
        [charityLogo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:CLOUDINARY_IMAGE_URL,currentLocation.charityId.picture]]];
        charityContributionTotal.text = [NSString stringWithFormat:@"$25.00"];
        charityDescription.text = currentLocation.charityId.description;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
