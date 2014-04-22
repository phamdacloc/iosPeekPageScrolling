//
//  ViewController.m
//  scrolling
//
//  Created by Pham Dac Loc on 4/22/14.
//  Copyright (c) 2014 Loc D. Pham. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *pageContents;
@property (nonatomic, strong) NSMutableArray *pageViews;

//@property (nonatomic, strong) NSLayoutConstraint *pageViewTopConstraint;
//@property (nonatomic, strong) NSLayoutConstraint *pageViewBottomConstraint;

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView *page1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    UIView *page2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 350, 350)];
    UIView *page3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
    UIView *page4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 450, 450)];
    UIView *page5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
    page5.tag = 999;
    
    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 475, 50, 40)];
    myLabel.tag = 888;
    [myLabel setText:@"bottom"];
    [page5 addSubview:myLabel];
    
    page1.backgroundColor = [UIColor redColor];
    page2.backgroundColor = [UIColor blueColor];
    page3.backgroundColor = [UIColor yellowColor];
    page4.backgroundColor = [UIColor greenColor];
    page5.backgroundColor = [UIColor purpleColor];
    self.pageContents = [NSArray arrayWithObjects:
                         page1, page2, page3, page4, page5, nil];
    
    NSInteger pageCount = self.pageContents.count;
    
    // Set up the page control
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = pageCount;
    
    // Set up the array to hold the views for each page
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i) {
        [self.pageViews addObject:[NSNull null]];
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Set up the content size of the scroll view
    CGSize pagesScrollViewSize = self.horizontalScrollView.frame.size;
    self.horizontalScrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageContents.count, pagesScrollViewSize.height);

    // Load the initial set of pages that are on screen
    [self loadVisiblePages];
}

#pragma mark -

- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.horizontalScrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.horizontalScrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.pageControl.currentPage = page;
    
    // Work out which pages we want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    for (NSInteger i=lastPage+1; i<self.pageContents.count; i++) {
        [self purgePage:i];
    }
}

- (void)loadPage:(NSInteger)page {
    
    if (page < 0 || page >= self.pageContents.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Load an individual page, first seeing if we've already loaded it
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        
        CGRect frame = self.horizontalScrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        frame = CGRectInset(frame, 10.0f, 0.0f);
        
        UIView *newPageView = [self.pageContents objectAtIndex:page];
        frame.size.height = newPageView.frame.size.height;
        newPageView.frame = frame;
        
        // Make the tallest/heighest page content be the height of the horizontal scroll view content
        if (frame.size.height > _horizontalScrollView.contentSize.height) {
            // Set new content size
            CGSize newSize = CGSizeMake(_horizontalScrollView.contentSize.width, frame.size.height);
            _horizontalScrollView.contentSize = newSize;
        }
        
        [self.horizontalScrollView addSubview:newPageView];
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
    
    // Allow verticle scroll to the bottom of the CURRENT page height (not tallest page height)
    if (self.pageControl.currentPage == page) {
        
        pageView = [self.pageViews objectAtIndex:page];
        
        if ((NSNull*)pageView != [NSNull null]) {
            _verticalScrollView.contentSize = CGSizeMake(_verticalScrollView.frame.size.width,
                                                         _horizontalScrollView.frame.origin.y + pageView.frame.size.height);
            
            // Make the horizontal scroll frame height equals to the page contents height to prevent scrolling of the
            // page content inside the horizontal scrollView.  This allow the user to scroll vertically even though the
            // touchpoint is inside of horizontal scrollView.
            CGRect adjustedFrame;
            adjustedFrame.origin = _horizontalScrollView.frame.origin;
            adjustedFrame.size = CGSizeMake(_horizontalScrollView.frame.size.width, _horizontalScrollView.contentSize.height);
            _horizontalScrollView.frame = adjustedFrame;
            
            adjustedFrame = CGRectMake(_scrollViewContainer.frame.origin.x, _scrollViewContainer.frame.origin.y, _scrollViewContainer.frame.size.width, pageView.frame.size.height);
            
            _scrollViewContainer.frame = adjustedFrame;
        }
    }
}

- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= self.pageContents.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        NSLog(@"purgePage:%d", page);
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages which are now on screen
    [self loadVisiblePages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
