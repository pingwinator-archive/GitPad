//
//  GPNavigationBar.m
//  GitPad
//
//  Created by Robert Widmann on 11/29/12.
//  Copyright (c) 2012 CodaFi. All rights reserved.
//

#import "GPNavigationBar.h"
#import <QuartzCore/QuartzCore.h>
#import "GPUtilities.h"

static CGFloat const GPCornerClipRadius = 4.0;

@interface GPNavigationBar ()

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
		_label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
		_label.layer.shadowOpacity = 0.75;
		_label.layer.shadowRadius = 0.0;
		_label.layer.shadowColor = [UIColor blackColor].CGColor;
		_label.layer.shadowOffset = CGSizeMake(0.0, -0.5);
		[self addSubview:_label];
		
		_imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.bounds) - 22, 0, 44, 44)];
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
			_imageView.frame = CGRectMake(CGRectGetMidX(self.bounds)/2, 0, 44, 44);
		}
		_imageView.contentMode = UIViewContentModeCenter;
		[self addSubview:_imageView];
    }
    return self;
}

-(void)setTitle:(NSString *)title {
	[self.label setText:title];
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	[self.label setFrame:self.bounds];
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
	CGContextRef context = UIGraphicsGetCurrentContext();

	if (self.drawRect != nil) {
		self.drawRect(self, rect);
		CGRect clippingRect = [self bounds];
		
		CGPathRef clippingPath = GPCreateClippingPathWithRectAndRadius(clippingRect, GPCornerClipRadius);
		CGContextAddPath(context, clippingPath);
		CGContextClip(context);
		CGPathRelease(clippingPath);
		return;
	}
    CGRect drawingRect = [self bounds];
	
	UIColor *startColor = [UIColor colorWithWhite:0.970 alpha:1.000];
	UIColor *endColor = [UIColor colorWithWhite:0.936 alpha:1.000];
	
	CGRect clippingRect = drawingRect;
	
	CGGradientRef gradient = GPCreateGradientWithColors(startColor, endColor);
	CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMidX(drawingRect), CGRectGetMinY(drawingRect)),
								CGPointMake(CGRectGetMidX(drawingRect), CGRectGetMaxY(drawingRect)), 0);
	CGGradientRelease(gradient);
	
	[[UIColor colorWithWhite:0.873 alpha:1.000] set];
    CGContextSetLineWidth(context,1.0f);
    CGContextMoveToPoint(context,0.0f, CGRectGetMaxY(drawingRect));
    CGContextAddLineToPoint(context,CGRectGetMaxX(drawingRect), CGRectGetMaxY(drawingRect));
    CGContextStrokePath(context);
	
	CGPathRef clippingPath = GPCreateClippingPathWithRectAndRadius(clippingRect, GPCornerClipRadius);
	CGContextAddPath(context, clippingPath);
	CGContextClip(context);
	CGPathRelease(clippingPath);

}



@end
