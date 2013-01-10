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

@interface GPControlCenterViewController ()

@property (nonatomic, strong) GPLoginViewController *loginViewController;
@property (nonatomic, strong) GPNavigationController *loginNavigationBar;

@end

@implementation GPControlCenterViewController

+(id)controlCenterViewController {
	return [[self alloc]init];
}

-(id)init {
	if (self = [super init]) {
		self.view.backgroundColor = [UIColor darkGrayColor];
		[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_newLoginSuccessful) name:GPLoginViewControllerDidSuccessfulyLoginNotification object:nil];
	}
	return self;
}

-(void)viewDidAppear:(BOOL)animated {
	if ([self presentLoginViewControllerIfNeeded]) {
		
	} else {
		
	}
}

-(BOOL)presentLoginViewControllerIfNeeded {
	BOOL result = NO;
//	if ([[HKAccountManager sharedManager]accounts].count == 0) {
		[self _setupLoginViewControllerIfNeeded];
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
		[self presentViewController:self.loginNavigationBar animated:YES completion:^{
			
		}];
//#else
//		[self presentModalViewController:self.loginViewController animated:YES];
//#endif
//		
//		result = YES;
//	}
	return result;

}

-(void)_setupLoginViewControllerIfNeeded {
	if (self.loginViewController != nil || self.loginNavigationBar != nil) return;
	
	self.loginViewController = [[GPLoginViewController alloc]init];
	
	self.loginNavigationBar = [[GPNavigationController alloc]initWithRootViewController:self.loginViewController];
	[self.loginNavigationBar setModalPresentationStyle:UIModalPresentationFormSheet];

}

-(void)_newLoginSuccessful {
	[self dismissViewControllerAnimated:YES completion:NULL];
}

@end
