//
//  GPMainViewController.h
//  GitPad
//
//  Created by Robert Widmann on 12/6/12.
//  Copyright (c) 2012 CodaFi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KRAUser;

@interface GPMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) KRAUser *currentAccount;

- (void)gp_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated newNavigationBar:(BOOL)flag completion:(void (^)(void))completion;

@end
