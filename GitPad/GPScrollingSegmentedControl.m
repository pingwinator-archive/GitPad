//
//  GPScrollingSegmentedControl.m
//  GitPad
//
//  Created by Alex Widmann on 2/17/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "GPScrollingSegmentedControl.h"
#import "GPSegment.h"
@interface GPScrollingSegmentedControl ()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *segments;

@end

@implementation GPScrollingSegmentedControl

- (id)initWithFrame:(CGRect)frame andItems:(NSArray *)items inScrollView:(UIScrollView*)scrollView {
    self = [super initWithFrame:frame];
	
	_segments = [NSMutableArray new];

	self.scrollView = scrollView;
	[self _fillWithItems:items];
	RACBinding *contentOffsetBinding = RACBind(self.scrollView.contentOffset);
	@weakify(self);
	[contentOffsetBinding subscribeNext:^(NSValue *contentOffset) {
		@strongify(self);
		CGPoint offset = [contentOffset CGPointValue];
		[self.scrollView layoutSubviews];
		[(UITableView*)self.scrollView tableHeaderView].frame = (CGRect){ .origin.y = MIN(0,offset.y), .size.width = CGRectGetWidth(self.scrollView.frame), .size.height = 44 };
	}];
	[(UITableView*)scrollView setTableHeaderView:self];
	
    return self;
}

- (void)_fillWithItems:(NSArray*)items {
	if (items.count > 0) {
		CGRect fillRect = CGRectInset(self.bounds, 8, 8);
		fillRect.origin.x += 2;
		fillRect.origin.y += 2;
		
		CGRect slice, remainder;
		CGFloat itemWidth = CGRectGetWidth(fillRect)/items.count;
		CGRectDivide(fillRect, &slice, &remainder, itemWidth, CGRectMinXEdge);
		for (int i = 0; i < items.count; i++) {
			GPSegment *newSegment = [[GPSegment alloc]initWithFrame:slice];
			if (i > 0) {
				slice.origin.x += itemWidth;
			}
			if (i == 0) {
				newSegment.firstSegment = YES;
			} else if (i == items.count) {
				newSegment.lastSegment = YES;
			}
			[newSegment setFrame:slice];
			newSegment.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			[newSegment addTarget:self action:@selector(selectSegment:) forControlEvents:UIControlEventTouchUpInside];
			[newSegment setTitle:[items objectAtIndex:i]];
			[self addSubview:newSegment];
			[_segments addObject:newSegment];
		}
	}
}

- (void)selectSegment:(GPSegment*)segmentButton {
	_selectedSegmentIndex = [self.segments indexOfObject:segmentButton];
	for (GPSegment *segment in self.segments) {
		if (segment != segmentButton) {
			[segment setSelected:NO];
		} else {
			[segment setSelected:YES];
		}
	}
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex {
	[self selectSegment:[self.segments objectAtIndex:selectedSegmentIndex]];
}

- (void)layoutSubviews {
	CGRect fillRect = CGRectInset(self.bounds, 8, 8);
	
	CGRect slice, remainder;
	CGFloat itemWidth = CGRectGetWidth(fillRect)/self.segments.count;
	CGRectDivide(fillRect, &slice, &remainder, itemWidth, CGRectMinXEdge);
	for (int i = 0; i < self.segments.count; i++) {
		if (i > 0) {
			slice.origin.x += itemWidth;
		}
		GPSegment *segment = [self.segments objectAtIndex:i];
		[segment setFrame:slice];
	}
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
	[UIColor.whiteColor set];
	UIRectFill(rect);
	[super drawRect:rect];
	
	CGRect b = self.bounds;
	[[UIColor colorWithWhite:0.931 alpha:1.000] set];
	
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(currentContext, 1.f);
    CGContextMoveToPoint(currentContext, 0, CGRectGetHeight(b));
    CGContextAddLineToPoint(currentContext, CGRectGetWidth(b), CGRectGetHeight(b));
    CGContextStrokePath(currentContext);
}


@end
