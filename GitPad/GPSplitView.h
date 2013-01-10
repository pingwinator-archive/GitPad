//
//  GPSplitView.h
//  GitPad
//
//  Created by Robert Widmann on 12/6/12.
//  Copyright (c) 2012 CodaFi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPSplitView : UIView

-(id)initWithFrame:(CGRect)frame;

@property (nonatomic, strong, readonly) UIView *mainView;
@property (nonatomic, strong, readonly) UIView *sidebarView;

@end
