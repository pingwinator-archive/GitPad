//
//  GPRepositoryViewController.h
//  GitPad
//
//  Created by Alex Widmann on 2/17/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KRAUser;

@interface GPRepositoryListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *repositories;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) KRAUser *account;

- (void)setupWithFrame:(CGRect)frame;

- (void)showView;
- (void)hideView;
- (void)showViewAnimated:(BOOL)animated;
- (void)hideViewAnimated:(BOOL)animated;

@end
