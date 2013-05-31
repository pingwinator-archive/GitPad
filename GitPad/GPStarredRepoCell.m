//
//  GPStarredRepoCell.m
//  GitPad
//
//  Created by Robert Widmann on 5/30/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "GPStarredRepoCell.h"
#import "GPUtilities.h"
#import <KrakenKit/KrakenKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GPStarButton : UIButton
@property (nonatomic, strong) UILabel *customFontLabel;
@end

@implementation GPStarButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	// Initialization code
	self.layer.cornerRadius = 5.0f;
	self.layer.masksToBounds = YES;
	self.layer.borderWidth = 1.0f;
	self.layer.borderColor = [UIColor colorWithWhite:0.364 alpha:1.000].CGColor;
	self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	self.titleLabel.textAlignment = NSTextAlignmentCenter;
	_customFontLabel = [[UILabel alloc]initWithFrame:self.bounds];
	_customFontLabel.textAlignment = NSTextAlignmentLeft;
	_customFontLabel.backgroundColor = UIColor.clearColor;
	_customFontLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
	_customFontLabel.font = [UIFont fontWithName:@"GitHub Octicons" size:14.f];
	_customFontLabel.textColor = UIColor.whiteColor;
	_customFontLabel.text = @"\uf083";
	[self addSubview:_customFontLabel];
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.customFontLabel.frame = CGRectOffset(self.bounds, 10, 2);
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	CGRect drawingRect = self.bounds;
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGGradientRef gradient = NULL;
	if (!self.highlighted) {
		gradient = GPCreateGradientWithColors([UIColor colorWithWhite:0.471 alpha:1.000], [UIColor colorWithWhite:0.356 alpha:1.000]);
		CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMidX(drawingRect), CGRectGetMinY(drawingRect)),
									CGPointMake(CGRectGetMidX(drawingRect), CGRectGetMaxY(drawingRect)), 0);
	} else {
		gradient = GPCreateGradientWithColors([UIColor colorWithWhite:0.215 alpha:1.000], [UIColor colorWithWhite:0.260 alpha:1.000]);
		CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMidX(drawingRect), CGRectGetMinY(drawingRect)),
									CGPointMake(CGRectGetMidX(drawingRect), CGRectGetMaxY(drawingRect)), 0);
	}
	CGGradientRelease(gradient);
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
	[self setNeedsDisplay];
}

@end

@interface GPStarredRepoCell ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *customFontLabel;
@property (nonatomic, strong) UILabel *detailsLabel;
@property (nonatomic, strong) GPStarButton *starButton;

@end


@implementation GPStarredRepoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	
	self.backgroundColor = [UIColor colorWithWhite:0.931 alpha:1.000];
	
	_label = [[UILabel alloc]initWithFrame:CGRectZero];
	_label.backgroundColor = UIColor.clearColor;
	_label.numberOfLines = 1;
	_label.lineBreakMode = NSLineBreakByTruncatingTail;
	_label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_label.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
	_label.textColor = [UIColor colorWithRed:0.203 green:0.430 blue:0.718 alpha:1.000];

	_customFontLabel = [[UILabel alloc]initWithFrame:CGRectZero];
	_customFontLabel.textAlignment = NSTextAlignmentCenter;
	_customFontLabel.backgroundColor = UIColor.clearColor;
	_customFontLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
	_customFontLabel.font = [UIFont fontWithName:@"GitHub Octicons" size:36.f];

	_detailsLabel = [[UILabel alloc]initWithFrame:CGRectZero];
	_detailsLabel.backgroundColor = UIColor.clearColor;
	_detailsLabel.numberOfLines = 2;
	_detailsLabel.lineBreakMode = NSLineBreakByTruncatingTail;
	_detailsLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
	_detailsLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
	
	_starButton = [[GPStarButton alloc]initWithFrame:CGRectZero];
	_starButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.f];
	[_starButton setTitle:@"    Unstar" forState:UIControlStateNormal];
	[_starButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
	
	[self addSubview:_label];
	[self addSubview:_customFontLabel];
	[self addSubview:_detailsLabel];
	[self addSubview:_starButton];
//	[self addSubview:_dateLabel];
	
    return self;
}

-(void)setRepository:(KRARepository *)repository {
	_repository = repository;
	[self.label setText:repository.fullName];
	[self.customFontLabel setText:@"\uf001"];
	[self.detailsLabel setText:repository.repoDescription];
}

- (void)layoutSubviews {
	CGRect remainder, slice;
	CGRectDivide(self.bounds, &slice, &remainder, 50, CGRectMinXEdge);
	remainder.size.height -= 28;
	remainder.size.width -= 95;
	[self.label setFrame:remainder];
	remainder.size.height += 10;
	remainder.origin.y += 18;
	[self.detailsLabel setFrame:remainder];
	[self.label setNumberOfLines:1];
	[self.customFontLabel setFrame:slice];
	self.starButton.frame = (CGRect){ .origin.x = CGRectGetMaxX(self.bounds) - 95, .origin.y = CGRectGetMidY(self.bounds) - 15, .size = { 85, 30 } };
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	CGRect b = self.bounds;
	[[UIColor colorWithWhite:0.931 alpha:1.000] setStroke];
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(currentContext, 1.f);
    CGContextMoveToPoint(currentContext, 0, CGRectGetHeight(b));
    CGContextAddLineToPoint(currentContext, CGRectGetWidth(b), CGRectGetHeight(b));
    CGContextStrokePath(currentContext);
}

@end
