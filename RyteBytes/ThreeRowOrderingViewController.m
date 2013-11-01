////
////  ThreeRowOrderingViewController.m
////  RyteBytes
////
////  Created by Nicholas McMillan on 10/25/13.
////
////
//
//#import "ThreeRowOrderingViewController.h"
//
//@implementation ThreeRowOrderingViewController
//
//@synthesize scrollViewOne;
//@synthesize scrollViewTwo;
//@synthesize scrollViewThree;
//@synthesize scollViewOnePageViews;
//@synthesize scollViewTwoPageViews;
//@synthesize scollViewThreePageViews;
//@synthesize pageImages;
//@synthesize pageControlViewOne;
//@synthesize pageControlViewTwo;
//@synthesize pageControlViewThree;
//
//- (void)loadPage:(NSInteger)page withScrollView:(UIScrollView *)view {
//    if (page < 0 || page >= self.pageImages.count) {
//        // If it's outside the range of what you have to display, then do nothing
//        return;
//    }
//    
//    NSMutableArray *pages;
//    double y;
//    
//    switch (view.tag) {
//        case 1:
//            pages = scollViewOnePageViews;
//            y = scrollViewOne.bounds.origin.y;
//            break;
//        case 2:
//            pages = scollViewTwoPageViews;
//            y = scrollViewTwo.bounds.origin.y;
//            break;
//        case 3:
//            pages = scollViewThreePageViews;
//            y = scrollViewThree.bounds.origin.y;
//            break;
//        default:
//            break;
//    }
//    
//    // 1
//    UIView *pageView = [pages objectAtIndex:page];
//    if ((NSNull*)pageView == [NSNull null]) {
//        // 2
//        CGRect frame = view.bounds;
//        frame.origin.x = frame.size.width * page;
//        frame.origin.y = y;
////        frame.origin.y = 0.0f;
////        frame.origin.y = view
//        
//        // 3
//        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.pageImages objectAtIndex:page]];
//        newPageView.contentMode = UIViewContentModeScaleAspectFit;
//        newPageView.frame = frame;
//        [view addSubview:newPageView];
//        // 4
//        [pages replaceObjectAtIndex:page withObject:newPageView];
//    }
//}
//
//- (void)loadVisiblePagesWithScrollView:(UIScrollView *)view {
//    // First, determine which page is currently visible
//    
//    UIPageControl *pageControl;
//    
//    switch (view.tag) {
//        case 1:
//            pageControl = pageControlViewOne;
//            break;
//        case 2:
//            pageControl = pageControlViewTwo;
//            break;
//        case 3:
//            pageControl = pageControlViewThree;
//            break;
//        default:
//            break;
//    }
//    
//    CGFloat pageWidth = view.frame.size.width;
//    NSInteger page = (NSInteger)floor((view.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
//    
//    // Update the page control
//    pageControl.currentPage = page;
//    
//    // Work out which pages you want to load
//    NSInteger firstPage = page - 1;
//    NSInteger lastPage = page + 1;
//    
//    // Purge anything before the first page
//    for (NSInteger i=0; i<firstPage; i++) {
//        [self purgePage:i];
//    }
//    
//	// Load pages in our range
//    for (NSInteger i=firstPage; i<=lastPage; i++) {
//        [self loadPage:i withScrollView:view];
//    }
//    
//	// Purge anything after the last page
//    for (NSInteger i=lastPage+1; i<self.pageImages.count; i++) {
//        [self purgePage:i];
//    }
//}
//
//- (void)purgePage:(NSInteger)page  {
//    if (page < 0 || page >= self.pageImages.count) {
//        // If it's outside the range of what you have to display, then do nothing
//        return;
//    }
//    
//    // Remove a page from the scroll view and reset the container array
//    UIView *pageView = [self.scollViewOnePageViews objectAtIndex:page];
//    if ((NSNull*)pageView != [NSNull null]) {
//        [pageView removeFromSuperview];
//        [self.scollViewOnePageViews replaceObjectAtIndex:page withObject:[NSNull null]];
//    }
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    // Load the pages that are now on screen
//    [self loadVisiblePagesWithScrollView:scrollView];
//}
//
////called before loading the actual view
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    CGSize pagesScrollViewSize = self.scrollViewOne.frame.size;
//    self.scrollViewOne.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
//    self.scrollViewTwo.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
//    self.scrollViewThree.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
//    
//    [self loadVisiblePagesWithScrollView:scrollViewOne];
//    [self loadVisiblePagesWithScrollView:scrollViewTwo];
//    [self loadVisiblePagesWithScrollView:scrollViewThree];
//}
//
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//	// Do any additional setup after loading the view.
//    
//    //    [self.scrollView setScrollEnabled:true];
//    //    [self.scrollView setPagingEnabled:true];
//    
//    // 1
//    self.pageImages = [NSArray arrayWithObjects:
//                       [UIImage imageNamed:@"welcome_chicken.jpg"],
//                       [UIImage imageNamed:@"welcome_pasta.jpg"],
//                       [UIImage imageNamed:@"welcome_packaged.jpg"],nil];
//    
//    NSInteger pageCount = self.pageImages.count;
//    
//    // 2
//    self.pageControlViewOne.currentPage = 0;
//    self.pageControlViewOne.numberOfPages = pageCount;
//    
//    self.pageControlViewTwo.currentPage = 0;
//    self.pageControlViewTwo.numberOfPages = pageCount;
//    
//    self.pageControlViewThree.currentPage = 0;
//    self.pageControlViewThree.numberOfPages = pageCount;
//    
//    
//    // 3
//    self.scollViewOnePageViews = [[NSMutableArray alloc] init];
//    for (NSInteger i = 0; i < pageCount; ++i) {
//        [self.scollViewOnePageViews addObject:[NSNull null]];
//    }
//    
//    self.scollViewTwoPageViews = [[NSMutableArray alloc] init];
//    for (NSInteger i = 0; i < pageCount; ++i) {
//        [self.scollViewTwoPageViews addObject:[NSNull null]];
//    }
//    
//    self.scollViewThreePageViews = [[NSMutableArray alloc] init];
//    for (NSInteger i = 0; i < pageCount; ++i) {
//        [self.scollViewThreePageViews addObject:[NSNull null]];
//    }
//}
//
//@end
