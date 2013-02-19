//
//  GPSegment.m
//  GitPad
//
//  Created by Alex Widmann on 2/18/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "GPSegment.h"

const CGFloat GPCornerClipRadius = 8.0;

@interface GPSegment ()

@property (nonatomic, strong) UILabel *segmentTitleLabel;

@end

@implementation GPSegment

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        _segmentTitleLabel = [[UILabel alloc] initWithFrame:self.bounds];
		_segmentTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _segmentTitleLabel.backgroundColor = UIColor.clearColor;
        _segmentTitleLabel.textAlignment = NSTextAlignmentCenter;
        _segmentTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.f];
        _segmentTitleLabel.textColor = [UIColor colorWithWhite:0.391 alpha:1.000];
        [self addSubview:_segmentTitleLabel];
    }
    return self;
}

- (void) setTitle:(NSString *)title {
    [_segmentTitleLabel setText:title];
	_title = title;
}

- (void)layoutSubviews {
	[_segmentTitleLabel setFrame:self.bounds];
}

#pragma mark - Drawing

- (void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // Drawing code
    CGRect b = self.bounds;
	
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    UIColor *startColor = [UIColor colorWithWhite:0.970 alpha:1.000];
    UIColor *endColor = [UIColor colorWithWhite:0.936 alpha:1.000];
    if (self.isHighlighted)
    {
        startColor = [UIColor colorWithRed:0.975 green:0.980 blue:0.990 alpha:1.000];
        endColor = [UIColor colorWithRed:0.832 green:0.877 blue:0.921 alpha:1.000];
    }
	
    CGGradientRef gradient = createGradientWithColors(startColor, endColor);
    CGContextDrawLinearGradient(context, gradient, CGPointMake( CGRectGetMidX(b), CGRectGetMinY(b) ),
                                CGPointMake( CGRectGetMidX(b), CGRectGetMaxY(b) ), 0);
    CGGradientRelease(gradient);
	
	[[UIColor colorWithWhite:0.873 alpha:1.000] set];

    if (!self.isFirstSegment)
    {
        CGContextSetLineWidth(context, 1.0f);
        CGContextMoveToPoint(context, 0.0f, 0.0f);
        CGContextAddLineToPoint(context, 0.0f, CGRectGetMaxY(b) );
        CGContextStrokePath(context);
    }
	if (!self.isLastSegment) {
		CGContextSetLineWidth(context, 1.0f);
		CGContextMoveToPoint(context, CGRectGetMaxX(b), 0.0f);
		CGContextAddLineToPoint(context, CGRectGetMaxX(b), CGRectGetMaxY(b) );
		CGContextStrokePath(context);
	}
	
	UIColor *contextColor = [UIColor colorWithWhite:0.897 alpha:1.000];
	CGContextSetLineWidth(context, 1.0f);
	CGContextMoveToPoint(context, CGRectGetMinX(b), 0.f);
	CGContextAddLineToPoint(context, CGRectGetMaxX(b), 0.f);
	CGContextStrokePath(context);
	
	contextColor = [UIColor colorWithWhite:0.873 alpha:1.000];
    if (self.isSelected)
    {
        contextColor = [UIColor colorWithRed:0.771 green:0.830 blue:0.887 alpha:1.000];
    }
    else if (self.isHighlighted)
    {
        contextColor = [UIColor colorWithRed:0.771 green:0.830 blue:0.887 alpha:1.000];
    }
    [contextColor set];
    CGContextSetLineWidth(context, 1.0f);
    CGContextMoveToPoint(context, 0.0f, CGRectGetMaxY(b) - 1);
    CGContextAddLineToPoint(context, CGRectGetMaxX(b), CGRectGetMaxY(b) - 1);
    CGContextStrokePath(context);
	
    contextColor = [UIColor colorWithWhite:0.821 alpha:1.000];
    if (self.isSelected)
    {
        contextColor = [UIColor colorWithRed:0.775 green:0.329 blue:0.108 alpha:1.000];
    }
    else if (self.isHighlighted)
    {
        contextColor = [UIColor colorWithWhite:0.746 alpha:1.000];
    }
    [contextColor set];
    CGContextSetLineWidth(context, 2.0f);
    CGContextMoveToPoint( context, 0.0f, CGRectGetMaxY(b) );
    CGContextAddLineToPoint( context, CGRectGetMaxX(b), CGRectGetMaxY(b) );
    CGContextStrokePath(context);
	
	
    if (self.isFirstSegment)
    {
        CGPathRef clippingPath = createClippingPathWithRectAndRadius(b, GPCornerClipRadius, YES);
        CGContextAddPath(context, clippingPath);
        CGContextClip(context);
        CGPathRelease(clippingPath);
    }
	if (self.isLastSegment)
    {
        CGPathRef clippingPath = createClippingPathWithRectAndRadius(b, GPCornerClipRadius, NO);
        CGContextAddPath(context, clippingPath);
        CGContextClip(context);
        CGPathRelease(clippingPath);
    }
}

- (void) setSelected:(BOOL)selected {
    [super setSelected:selected];
}

- (void) setHighlighted:(BOOL)highlighted {
    [self setNeedsDisplay];
    [super setHighlighted:highlighted];
}

static inline CGGradientRef createGradientWithColors(UIColor *startingColor, UIColor *endingColor)
{
    CGFloat locations[2] = {
        0.0f, 1.0f,
    };
#if __has_feature(objc_arc)
    CFArrayRef colors = (__bridge CFArrayRef)[NSArray arrayWithObjects:(__bridge id)[startingColor CGColor], (__bridge id)[endingColor CGColor], nil];
#else
    CFArrayRef colors = (CFArrayRef)[NSArray arrayWithObjects : (id)[startingColor CGColor], (id)[endingColor CGColor], nil];
#endif
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, locations);
    CGColorSpaceRelease(colorSpace);
    return gradient;
}

static inline CGPathRef createClippingPathWithRectAndRadius(CGRect rect, CGFloat radius, BOOL first)
{
    CGMutablePathRef path = CGPathCreateMutable();
    if (first)
    {
        CGPathMoveToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
        CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect));
        CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect) + radius, CGRectGetMaxY(rect), radius);
        CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect) - radius, 0.f);
        CGPathAddArcToPoint(path, NULL,  CGRectGetMinX(rect), 0.f, CGRectGetMinX(rect), 0.f, radius);
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), 0.f);
        CGPathCloseSubpath(path);
    }
    else
    {
        CGPathMoveToPoint( path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect) );
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect) - radius);
        CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMaxX(rect) + radius, CGRectGetMaxY(rect), radius);
        CGPathAddLineToPoint( path, NULL, CGRectGetMaxX(rect) - radius, CGRectGetMaxY(rect) );
        CGPathAddArcToPoint(path, NULL,  CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMaxX(rect), CGRectGetMaxY(rect) + radius, radius);
        CGPathAddLineToPoint( path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect));
        CGPathCloseSubpath(path);
    }
    return path;
}

@end