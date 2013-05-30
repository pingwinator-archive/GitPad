//
//  GPLoginButton.m
//  GitPad
//
//  Created by Robert Widmann on 5/24/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "GPLoginButton.h"
#import "GPUtilities.h"
#import <QuartzCore/QuartzCore.h>

@implementation GPLoginButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.layer.cornerRadius = 5.0f;
		self.layer.masksToBounds = YES;
		self.layer.borderWidth = 1.0f;
		self.layer.borderColor = [UIColor colorWithRed:0.269 green:0.578 blue:0.168 alpha:1.000].CGColor;
		self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
		self.backgroundColor = [UIColor colorWithRed:0.430 green:0.758 blue:0.316 alpha:1.000];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
	[super setHighlighted:highlighted];
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGRect drawingRect = self.bounds;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIColor *startColor = [UIColor colorWithRed:0.430 green:0.758 blue:0.316 alpha:1.000];
	UIColor *endColor = [UIColor colorWithRed:0.320 green:0.653 blue:0.210 alpha:1.000];
	if (self.highlighted) {
		startColor = [UIColor colorWithRed:0.278 green:0.564 blue:0.183 alpha:1.000];
		endColor = [UIColor colorWithRed:0.234 green:0.470 blue:0.152 alpha:1.000];
	}
	
	CGGradientRef gradient = GPCreateGradientWithColors(startColor, endColor);
	CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMidX(drawingRect), CGRectGetMinY(drawingRect)),
								CGPointMake(CGRectGetMidX(drawingRect), CGRectGetMaxY(drawingRect)), 0);
	[UIColor.blackColor setStroke];
	CGContextStrokePath(context);
	
	CGGradientRelease(gradient);
}


@end
