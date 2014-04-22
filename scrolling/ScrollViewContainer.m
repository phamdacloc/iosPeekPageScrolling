//
//  ScrollViewContainer.m
//  scrolling
//
//  Created by Pham Dac Loc on 4/22/14.
//  Copyright (c) 2014 Loc D. Pham. All rights reserved.
//

#import "ScrollViewContainer.h"

@implementation ScrollViewContainer

// Intercept the touchpoint and pass it to the inner scrollview
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        return _innerScrollView;
    }
    return view;
}



@end
