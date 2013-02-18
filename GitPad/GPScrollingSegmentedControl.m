//
//  GPScrollingSegmentedControl.m
//  GitPad
//
//  Created by Alex Widmann on 2/17/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "GPScrollingSegmentedControl.h"

@interface GPScrollingSegmentedControl ()

@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation GPScrollingSegmentedControl

- (id)initWithItems:(NSArray *)items inScrollView:(UIScrollView*)scrollView;
{
    self = [super initWithItems:items];
    if (self) {
		self.scrollView = scrollView;
        RACBinding *contentOffsetBinding = RACBind(self.scrollView.contentOffset);
		@weakify(self);
		[contentOffsetBinding subscribeNext:^(NSValue *contentOffset) {
			@strongify(self);
			CGPoint offset = [contentOffset CGPointValue];
			[self.scrollView layoutSubviews];
			[(UITableView*)self.scrollView tableHeaderView].frame = CGRectMake(0,MIN(0,offset.y),320,44);;
		}];
		[(UITableView*)scrollView setTableHeaderView:self];
    }
    return self;
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
