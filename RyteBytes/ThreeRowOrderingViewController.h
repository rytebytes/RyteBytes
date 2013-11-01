//
//  ThreeRowOrderingViewController.h
//  RyteBytes
//
//  Created by Nicholas McMillan on 10/25/13.
//
//

#import <UIKit/UIKit.h>

@interface ThreeRowOrderingViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollViewOne;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollViewTwo;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollViewThree;

@property (nonatomic, strong) IBOutlet UIPageControl *pageControlViewOne;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControlViewTwo;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControlViewThree;

@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) NSMutableArray *scollViewOnePageViews;
@property (nonatomic, strong) NSMutableArray *scollViewTwoPageViews;
@property (nonatomic, strong) NSMutableArray *scollViewThreePageViews;

- (void)loadVisiblePagesWithScrollView:(UIScrollView*)view;
- (void)loadPage:(NSInteger)page withScrollView:(UIScrollView*)view;
- (void)purgePage:(NSInteger)page;

@end
