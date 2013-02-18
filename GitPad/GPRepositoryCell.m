//
//  GPRepositoryCell.m
//  GitPad
//
//  Created by Alex Widmann on 2/17/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "GPRepositoryCell.h"
#import <KrakenKit.h>

@interface GPRepositoryCell ()

@property (nonatomic, strong) KRGithubRepository *repository;
@property (nonatomic, strong) UILabel *label;

@end

@implementation GPRepositoryCell

- (id)initWithRepository:(KRGithubRepository*)repo style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	_repository = repo;
	_label = [[UILabel alloc]initWithFrame:CGRectZero];
	[_label setFont:[UIFont fontWithName:@"Helvetica" size:13]];
	[_label setText:repo.name];
	[_label setBackgroundColor:[UIColor clearColor]];
	[self addSubview:_label];
	
	return self;
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	if (self.repository.isPrivateRepository) {
		[[UIColor colorWithRed:1.000 green:0.998 blue:0.898 alpha:1.000]set];
		UIRectFill(rect);
	}
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[self.label setFrame:CGRectInset(self.bounds, 30, 0)];
}


@end
