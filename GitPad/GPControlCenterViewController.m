//
//  GPControlCenterViewController.m
//  GitPad
//
//  Created by Robert Widmann on 11/29/12.
//  Copyright (c) 2012 CodaFi. All rights reserved.
//

#import "GPControlCenterViewController.h"
#import "GPLoginViewController.h"
#import "GPNavigationController.h"
#import "GPConstants.h"
#import "GPAppDelegate.h"

@interface GPControlCenterViewController ()

@property (nonatomic, strong) GPLoginViewController *loginViewController;
@property (nonatomic, strong) GPNavigationController *loginNavigationBar;
@property (nonatomic, assign) GPAppDelegate *delegate;

@end

@implementation GPControlCenterViewController

+(id)controlCenterViewController {
	return [[self alloc]init];
}

-(id)init {
	if (self = [super init]) {
		_delegate = [[UIApplication sharedApplication]delegate];
		self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
		
	}
	return self;
}



@end
