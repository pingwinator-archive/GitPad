//
//  GPRepositoryCell.h
//  GitPad
//
//  Created by Alex Widmann on 2/17/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KRARepository;

@interface GPRepositoryCell : UITableViewCell

- (id)initWithRepository:(KRARepository*)repo style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
