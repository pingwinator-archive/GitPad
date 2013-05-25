//
//  GPUtilities.m
//  GitPad
//
//  Created by Robert Widmann on 5/24/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "GPUtilities.h"

inline CGGradientRef GPCreateGradientWithColors(UIColor *startingColor, UIColor *endingColor) {
    CGFloat locations[2] = { 0.0f, 1.0f };
    CFArrayRef colors = (__bridge CFArrayRef)@[(__bridge id)startingColor.CGColor, (__bridge id)endingColor.CGColor
											   ];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, locations);
    CGColorSpaceRelease(colorSpace);
    return gradient;
}

inline CGPathRef GPCreateClippingPathWithRectAndRadius(CGRect rect, CGFloat radius) {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect)-radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMinX(rect)+radius, CGRectGetMinY(rect), radius);
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect)-radius, CGRectGetMinY(rect));
    CGPathAddArcToPoint(path, NULL,  CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMinY(rect)+radius, radius);
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGPathCloseSubpath(path);
    return path;
}