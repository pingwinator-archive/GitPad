//
//  GPProfileContainerView.m
//  GitPad
//
//  Created by Alex Widmann on 2/18/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "GPProfileContainerView.h"
#import "UIImageView+WebCache.h"
#import <KrakenKit.h>

@interface GPProfileContainerView ()

@property (nonatomic, strong) UIImageView *profileImageView;
//@property (nonatomic, strong) UILabel *profileImageView;

@end

@implementation GPProfileContainerView

- (id)initWithFrame:(CGRect)frame andAccount:(KRGithubAccount*)account;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		_profileImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
		RACSignal *avatarURLSigal = RACAbleWithStart(account.avatarURL) 
		[_profileImageView rac_liftSelector:@selector(setImageWithURL:) withObjects:avatarURLSigal];
		[self addSubview:_profileImageView];
    }
    return self;
}

- (void)layoutSubviews {
	CGRect remainder, slice;
	_profileImageView.frame = CGRectMake(0, 0, 160, 160);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
