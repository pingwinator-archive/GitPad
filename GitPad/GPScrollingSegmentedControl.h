//
//  GPScrollingSegmentedControl.h
//  GitPad
//
//  Created by Alex Widmann on 2/17/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPScrollingSegmentedControl : UIView

- (id)initWithFrame:(CGRect)frame andItems:(NSArray *)items inScrollView:(UIScrollView*)scrollView;

@property (nonatomic, assign) NSInteger selectedSegmentIndex;

@end
