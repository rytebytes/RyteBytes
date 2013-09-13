//
//  LoginController.m
//  RyteBytes
//
//  Created by Nicholas McMillan on 6/22/13.
//
//

#import "CreateOrLoginViewController.h"
#import "CreateAccountViewController.h"
#import "TabBarController.h"

@implementation CreateOrLoginViewController

@synthesize scrollView;
@synthesize pageControl;
@synthesize pageImages;
@synthesize pageViews;

- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    
    // 1
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        // 2
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        // 3
        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.pageImages objectAtIndex:page]];
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        [self.scrollView addSubview:newPageView];
        // 4
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
}

- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.pageControl.currentPage = page;
    
    // Work out which pages you want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    
	// Load pages in our range
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    
	// Purge anything after the last page
    for (NSInteger i=lastPage+1; i<self.pageImages.count; i++) {
        [self purgePage:i];
    }
}

- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages that are now on screen
    [self loadVisiblePages];
}

//executed every time the screen appears
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser) { //if there is a valid current user, send them to the order screen
        NSLog(@"currentUser email : %@",currentUser.email);
//        [self performSegueWithIdentifier:@"ValidUser" sender:self];
    }
}

//only called once
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    [self.scrollView setScrollEnabled:true];
//    [self.scrollView setPagingEnabled:true];
    
    // 1
    self.pageImages = [NSArray arrayWithObjects:
                       [UIImage imageNamed:@"welcome_chicken.jpg"],
                       [UIImage imageNamed:@"welcome_pasta.jpg"],
                       [UIImage imageNamed:@"welcome_packaged.jpg"],nil];
    
    NSInteger pageCount = self.pageImages.count;
    
    // 2
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = pageCount;
    
    // 3
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i) {
        [self.pageViews addObject:[NSNull null]];
    }
    
}

//called before loading the actual view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
    
    [self loadVisiblePages];
}

// Create the log in view controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"LoginAction"])
	{
        LoginViewController *loginViewController = segue.destinationViewController;

        loginViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsDismissButton;
        [loginViewController setDelegate:loginViewController]; // Set ourselves as the delegate
    }
    else if ([segue.identifier isEqualToString:@"ValidUser"])
    {
        TabBarController *tabBarController = segue.destinationViewController;
        tabBarController.selectedIndex = ORDER_TAB;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
