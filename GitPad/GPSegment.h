//
//  GPSegment.h
//  GitPad
//
//  Created by Alex Widmann on 2/18/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPSegment : UIButton

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign, getter = isFirstSegment) BOOL firstSegment;
@property (nonatomic, assign, getter = isLastSegment) BOOL lastSegment;

@end
