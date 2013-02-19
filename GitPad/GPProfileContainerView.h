//
//  GPProfileContainerView.h
//  GitPad
//
//  Created by Alex Widmann on 2/18/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KRGithubAccount;

@interface GPProfileContainerView : UIView

- (id)initWithFrame:(CGRect)frame andAccount:(KRGithubAccount*)account;

@end
