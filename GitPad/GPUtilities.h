//
//  GPUtilities.h
//  GitPad
//
//  Created by Robert Widmann on 5/24/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <Foundation/Foundation.h>

extern inline CGGradientRef GPCreateGradientWithColors(UIColor *startingColor, UIColor *endingColor);
extern inline CGPathRef GPCreateClippingPathWithRectAndRadius(CGRect rect, CGFloat radius);
