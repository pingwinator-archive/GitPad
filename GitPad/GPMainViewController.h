//
//  GPMainViewController.h
//  GitPad
//
//  Created by Robert Widmann on 12/6/12.
//  Copyright (c) 2012 CodaFi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KRGithubAccount;

@interface GPMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) KRGithubAccount *currentAccount;

@end
