//
//  GPAccountViewController.h
//  GitPad
//
//  Created by Alex Widmann on 2/18/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GPAccount, GPNavigationBar;

@interface GPAccountViewController : UIViewController


- (id)initWithAccount:(GPAccount*)account navigationBar:(GPNavigationBar*)navigationBar;

@property (nonatomic, strong, readonly) GPAccount *account;

@end
