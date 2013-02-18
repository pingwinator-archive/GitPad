//
//  GPScrollingSegmentedControl.h
//  GitPad
//
//  Created by Alex Widmann on 2/17/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPScrollingSegmentedControl : UISegmentedControl

- (id)initWithItems:(NSArray *)items inScrollView:(UIScrollView*)scrollView;

@end
