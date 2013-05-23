//
//  GPNewsFeedCell.h
//  GitPad
//
//  Created by Robert Widmann on 1/10/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KRAEvent;

@interface GPNewsFeedCell : UITableViewCell

@property (nonatomic, strong) KRAEvent *event;

@end
