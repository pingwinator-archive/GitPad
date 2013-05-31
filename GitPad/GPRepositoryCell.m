//
//  GPRepositoryCell.m
//  GitPad
//
//  Created by Alex Widmann on 2/17/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "GPRepositoryCell.h"

@interface GPRepositoryCell ()

@property (nonatomic, strong) KRARepository *repository;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *octiconIconLabel;

@end

@implementation GPRepositoryCell

- (id)initWithRepository:(KRARepository*)repo style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	_repository = repo;
	_label = [[UILabel alloc]initWithFrame:CGRectZero];
	[_label setFont:[UIFont fontWithName:@"Helvetica" size:13]];
	[_label setText:repo.name];
	[_label setBackgroundColor:[UIColor clearColor]];
	[self addSubview:_label];
	
	_octiconIconLabel = [[UILabel alloc]initWithFrame:CGRectZero];
	[_octiconIconLabel setFont:[UIFont fontWithName:@"octicons" size:16]];
	_octiconIconLabel.textAlignment = NSTextAlignmentCenter;
	[_octiconIconLabel setText:_repoText(repo)];
	[_octiconIconLabel setBackgroundColor:[UIColor clearColor]];
	[self addSubview:_octiconIconLabel];
	return self;
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	if (self.repository.isPrivateRepo) {
		[[UIColor colorWithRed:1.000 green:0.998 blue:0.898 alpha:1.000]set];
		UIRectFill(rect);
	}
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[self.label setFrame:CGRectInset(self.bounds, 30, 0)];
	[self.octiconIconLabel setFrame:CGRectMake(0, 0, 30, CGRectGetHeight(self.bounds))];
}

NSString *_repoText(KRARepository* repo) {
	if (repo.isPrivateRepo) {
		return @"\uF200";
	}
	if (repo.isFork) {
		return @"\uF202";
	}
	return @"\uF201";
}

@end
