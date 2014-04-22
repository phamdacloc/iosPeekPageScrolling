//
//  ViewController.h
//  scrolling
//
//  Created by Pham Dac Loc on 4/22/14.
//  Copyright (c) 2014 Loc D. Pham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *verticalScrollView;

@property (weak, nonatomic) IBOutlet UIView *scrollViewContainer;

@property (weak, nonatomic) IBOutlet UIScrollView *horizontalScrollView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end
