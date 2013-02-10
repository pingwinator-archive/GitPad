//
//  GPNavigationBar.m
//  GitPad
//
//  Created by Robert Widmann on 11/29/12.
//  Copyright (c) 2012 CodaFi. All rights reserved.
//

#import "GPNavigationBar.h"
#import <QuartzCore/QuartzCore.h>

const CGFloat INCornerClipRadius = 4.0;
const CGFloat INButtonTopOffset = 3.0;

#define IN_COLOR_MAIN_START_L [UIColor colorWithWhite:0.66 alpha:1.0]
#define IN_COLOR_MAIN_END_L [UIColor colorWithWhite:0.9 alpha:1.0]
#define IN_COLOR_MAIN_BOTTOM_L [UIColor colorWithWhite:0.408 alpha:1.0]

#define IN_COLOR_NOTMAIN_START_L [UIColor colorWithWhite:0.878 alpha:1.0]
#define IN_COLOR_NOTMAIN_END_L [UIColor colorWithWhite:0.976 alpha:1.0]
#define IN_COLOR_NOTMAIN_BOTTOM_L [UIColor colorWithWhite:0.655 alpha:1.0]

static inline CGPathRef createClippingPathWithRectAndRadius(CGRect rect, CGFloat radius)
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect)-radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect)+radius, CGRectGetMaxY(rect), radius);
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect)-radius, CGRectGetMaxY(rect));
    CGPathAddArcToPoint(path, NULL,  CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMaxX(rect), CGRectGetMaxY(rect)-radius, radius);
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGPathCloseSubpath(path);
    return path;
}

inline CGGradientRef createGradientWithColors(UIColor *startingColor, UIColor *endingColor)
{
    CGFloat locations[2] = {0.0f, 1.0f, };
#if __has_feature(objc_arc)
    CFArrayRef colors = (__bridge CFArrayRef)[NSArray arrayWithObjects:(__bridge id)[startingColor CGColor], (__bridge id)[endingColor CGColor], nil];
#else
    CFArrayRef colors = (CFArrayRef)[NSArray arrayWithObjects:(id)[startingColor CGColor], (id)[endingColor CGColor], nil];
#endif
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, locations);
    CGColorSpaceRelease(colorSpace);
    return gradient;
}

@interface GPNavigationBar ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation GPNavigationBar

-(id)init {
	if (self = [super init]) {

	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		_label = [[UILabel alloc]initWithFrame:CGRectInset(frame, 0, 0)];
		_label.textColor = [UIColor grayColor];
		_label.backgroundColor = [UIColor clearColor];
		_label.textAlignment = NSTextAlignmentCenter;
		_label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f];
		_label.layer.shadowOpacity = 1.0;
		_label.layer.shadowRadius = 0.0;
		_label.layer.shadowColor = [UIColor blackColor].CGColor;
		_label.layer.shadowOffset = CGSizeMake(0.0, -1.0);
		[self addSubview:_label];
		
		_imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
		_imageView.contentMode = UIViewContentModeCenter;
		[self addSubview:_imageView];
    }
    return self;
}

-(void)setTitle:(NSString *)title {
	[self.label setText:title];
}

#pragma mark - Drawing

- (void)drawNoiseWithOpacity:(CGFloat)opacity
{
    static CGImageRef noiseImageRef = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        NSUInteger width = 124, height = width;
        NSUInteger size = width*height;
        char *rgba = (char *)malloc(size); srand(120);
        for(NSUInteger i=0; i < size; ++i){rgba[i] = rand()%256;}
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        CGContextRef bitmapContext =
        CGBitmapContextCreate(rgba, width, height, 8, width, colorSpace, kCGImageAlphaNone);
        CFRelease(colorSpace);
        noiseImageRef = CGBitmapContextCreateImage(bitmapContext);
        CFRelease(bitmapContext);
        free(rgba);
    });
	
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetAlpha(context, opacity);
    CGContextSetBlendMode(context, kCGBlendModeScreen);
	
    CGRect imageRect = (CGRect){CGPointZero, CGImageGetWidth(noiseImageRef), CGImageGetHeight(noiseImageRef)};
    CGContextDrawTiledImage(context, imageRect, noiseImageRef);
    CGContextRestoreGState(context);
}

-(void)setTitleImage:(UIImage *)titleImage {
	_titleImage = titleImage;
	[self.imageView setImage:titleImage];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	if (self.drawRect != nil) {
		self.drawRect(self, rect);
		return;
	}
    CGRect drawingRect = [self bounds];

	CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIColor *startColor = [UIColor colorWithWhite:0.970 alpha:1.000];
	UIColor *endColor = [UIColor colorWithWhite:0.936 alpha:1.000];
	
	CGRect clippingRect = drawingRect;

	CGPathRef clippingPath = createClippingPathWithRectAndRadius(clippingRect, INCornerClipRadius);
	CGContextAddPath(context, clippingPath);
	CGContextClip(context);
	CGPathRelease(clippingPath);
	
	CGGradientRef gradient = createGradientWithColors(startColor, endColor);
	CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMidX(drawingRect), CGRectGetMinY(drawingRect)),
								CGPointMake(CGRectGetMidX(drawingRect), CGRectGetMaxY(drawingRect)), 0);
	CGGradientRelease(gradient);
	
	[[UIColor colorWithWhite:0.873 alpha:1.000] set];
    CGContextSetLineWidth(context,1.0f);
    CGContextMoveToPoint(context,0.0f, CGRectGetMaxY(drawingRect));
    CGContextAddLineToPoint(context,CGRectGetMaxX(drawingRect), CGRectGetMaxY(drawingRect));
    CGContextStrokePath(context);

}



@end
