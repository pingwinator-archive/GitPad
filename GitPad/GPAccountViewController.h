//
//  GPAccountViewController.h
//  GitPad
//
//  Created by Alex Widmann on 2/18/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KRAUser, GPNavigationBar;

@interface GPAccountViewController : UIViewController


- (id)initWithAccount:(KRAUser *)account navigationBar:(GPNavigationBar *)navigationBar presentingViewController:(UIViewController *)presentingViewController;

@property (nonatomic, strong, readonly) KRAUser *account;

@end
