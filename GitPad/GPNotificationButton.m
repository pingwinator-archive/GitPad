//
//  GPNotificationButton.m
//  GitPad
//
//  Created by Robert Widmann on 1/10/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "GPNotificationButton.h"
#import "GPUtilities.h"

@implementation GPNotificationButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
	CGRect b = self.bounds;
		
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIColor *startColor = [UIColor colorWithWhite:0.970 alpha:1.000];
	UIColor *endColor = [UIColor colorWithWhite:0.936 alpha:1.000];

	CGGradientRef gradient = GPCreateGradientWithColors(startColor, endColor);
	CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMidX(b), CGRectGetMinY(b)),
								CGPointMake(CGRectGetMidX(b), CGRectGetMaxY(b)), 0);
	CGGradientRelease(gradient);

    CGContextSetLineWidth(context, 2.0);
	if (self.isHighlighted) {
		CGContextSetGrayFillColor(context, 0.577, 1.000);
	} else {
		CGContextSetGrayFillColor(context, 0.687, 1.000);
	}
    CGContextSetRGBStrokeColor(context, 0, 0, 1.0, 1.0);
    CGRect circlePoint = (CGRectMake(CGRectGetMidX(b) - 5, CGRectGetMidY(b) - 5, 10.0, 10.0));
    CGContextFillEllipseInRect(context, circlePoint);
	
	[[UIColor colorWithWhite:0.873 alpha:1.000] set];
    CGContextSetLineWidth(context,2.0f);
    CGContextMoveToPoint(context,1.0f, 0.0f);
    CGContextAddLineToPoint(context,1.0f, CGRectGetMaxY(b));
    CGContextStrokePath(context);
	
	CGContextSetLineWidth(context,2.0f);
    CGContextMoveToPoint(context,CGRectGetMaxX(b), 0.0f);
    CGContextAddLineToPoint(context,CGRectGetMaxX(b), CGRectGetMaxY(b));
    CGContextStrokePath(context);
	
	[[UIColor colorWithWhite:0.873 alpha:1.000] set];
    CGContextSetLineWidth(context,1.0f);
    CGContextMoveToPoint(context,0.0f, CGRectGetMaxY(b));
    CGContextAddLineToPoint(context,CGRectGetMaxX(b), CGRectGetMaxY(b));
    CGContextStrokePath(context);
}

- (void)setHighlighted:(BOOL)highlighted {
	[self setNeedsDisplay];
	[super setHighlighted:highlighted];
}

@end
