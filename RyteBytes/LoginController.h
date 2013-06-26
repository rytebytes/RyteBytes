//
//  LoginController.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 6/22/13.
//
//

#import <Parse/Parse.h>

@interface LoginController : UIViewController <PFLogInViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *loginView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;

@end
