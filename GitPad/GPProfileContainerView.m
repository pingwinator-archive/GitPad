//
//  GPProfileContainerView.m
//  GitPad
//
//  Created by Alex Widmann on 2/18/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "GPProfileContainerView.h"
#import "UIImageView+WebCache.h"

@interface GPProfileContainerView ()

@property (nonatomic, strong) KRAUser *account;
@property (nonatomic, strong) UIImageView *profileImageView;
//@property (nonatomic, strong) UILabel *profileImageView;

@end

@implementation GPProfileContainerView

- (id)initWithFrame:(CGRect)frame andAccount:(KRAUser*)account;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		_profileImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
		_account = account;
		RACSignal *avatarURLSigal = RACAbleWithStart(account.avatarURL);
		[_profileImageView rac_liftSelector:@selector(setImageWithURL:) withObjects:avatarURLSigal];
		[self addSubview:_profileImageView];
    }
    return self;
}

- (void)layoutSubviews {
	CGRect remainder, slice;
	_profileImageView.frame = (CGRect){ .origin.x = CGRectGetMidX(self.bounds) - 80, .origin.y = CGRectGetMidX(self.bounds) - 80, .size = { 160, 160 } };
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
