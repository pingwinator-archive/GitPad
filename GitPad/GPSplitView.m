//
//  GPSplitView.m
//  GitPad
//
//  Created by Robert Widmann on 12/6/12.
//  Copyright (c) 2012 CodaFi. All rights reserved.
//

#import "GPSplitView.h"

@interface GPSplitView ()

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIView *sidebarView;

@end

@implementation GPSplitView

-(id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame) * (2/3), CGRectGetHeight(frame))];
		[self.mainView setBackgroundColor:[UIColor redColor]];
		
		self.sidebarView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(frame) * (2/3), 0, CGRectGetWidth(frame) * (1/3), CGRectGetHeight(frame))];
		[self.mainView setBackgroundColor:[UIColor greenColor]];

	}
	return self;
}

@end
