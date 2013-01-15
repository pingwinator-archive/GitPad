//
//  GPNavigationBar.h
//  GitPad
//
//  Created by Robert Widmann on 11/29/12.
//  Copyright (c) 2012 CodaFi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GPNavigationBar;

typedef void (^GHNavigationBarDrawBlock)(GPNavigationBar *bar, CGRect dirtyRect);

@interface GPNavigationBar : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) GHNavigationBarDrawBlock drawRect;

@end
