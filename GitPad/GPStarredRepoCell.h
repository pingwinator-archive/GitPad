//
//  GPStarredRepoCell.h
//  GitPad
//
//  Created by Robert Widmann on 5/30/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KRARepository;

@interface GPStarredRepoCell : UITableViewCell

@property (nonatomic, strong) KRARepository *repository;

@end
