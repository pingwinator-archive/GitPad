//
//  GPMainViewController.m
//  GitPad
//
//  Created by Robert Widmann on 12/6/12.
//  Copyright (c) 2012 CodaFi. All rights reserved.
//

#import "GPMainViewController.h"
#import "GPAppDelegate.h"
#import "GPLoginViewController.h"
#import "GPNavigationController.h"
#import "GPNavigationBar.h"
#import "GPNotificationButton.h"
#import "GPNewsFeedCell.h"

@interface GPMainViewController ()

@property (nonatomic, assign) GPAppDelegate *delegate;
@property (nonatomic, strong) GPLoginViewController *loginViewController;
@property (nonatomic, strong) GPNavigationController *loginNavigationBar;
@property (nonatomic, strong) GPNavigationBar *navigationBar;
@property (nonatomic, strong) GPNotificationButton *notificationButton;
@property (nonatomic, strong) UITableView *newsFeedTableView;

@end

@implementation GPMainViewController

- (id)init {
	if (self = [super init]) {
		_delegate = [[UIApplication sharedApplication]delegate];
	}
	return self;
}

- (void)viewDidLoad {
	self.navigationBar = [[GPNavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
	self.navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[self.view addSubview:self.navigationBar];
	    
    CGRect remainder, slice;
	CGRectDivide(self.navigationBar.bounds, &slice, &remainder, 42, CGRectMinXEdge);
	self.notificationButton = [[GPNotificationButton alloc]initWithFrame:slice];
	[self.navigationBar addSubview:self.notificationButton];
	
	CGRectDivide(self.view.bounds, &slice, &remainder, 44, CGRectMinYEdge);
	self.newsFeedTableView = [[UITableView alloc]initWithFrame:remainder style:UITableViewStylePlain];
	self.newsFeedTableView.delegate = self;
	self.newsFeedTableView.dataSource = self;
	[self.view addSubview:self.newsFeedTableView];
}

- (void)viewDidAppear:(BOOL)animated {
	if ([self presentLoginViewControllerIfNeeded]) {
		
	} else {
		
	}
}

-(BOOL)presentLoginViewControllerIfNeeded {
	BOOL result = NO;
	//	if ([[HKAccountManager sharedManager]accounts].count == 0) {
	[self _setupLoginViewControllerIfNeeded];
	//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
	[self presentViewController:self.loginNavigationBar animated:YES completion:NULL];
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

#pragma mark - UITableViewDataSource

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *GPNewsFeedCellIdentifier = @"GPNewsFeedCellIdentifier";
	
	GPNewsFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:GPNewsFeedCellIdentifier];
    if (cell == nil) {
        cell = [[GPNewsFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GPNewsFeedCellIdentifier];
    }
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 98.0f;
}

@end
