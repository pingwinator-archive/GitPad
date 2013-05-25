//
//  GPMainViewController.m
//  GitPad
//
//  Created by Robert Widmann on 12/6/12.
//  Copyright (c) 2012 CodaFi. All rights reserved.
//

#import "GPAccountViewController.h"
#import "GPMainViewController.h"
#import "GPAppDelegate.h"
#import "GPLoginViewController.h"
#import "GPNavigationController.h"
#import "GPNavigationBar.h"
#import "GPNotificationButton.h"
#import "GPNewsFeedCell.h"
#import "GPRepositoryListViewController.h"
#import "BWStatusBarOverlay.h"
#import "GPScrollingSegmentedControl.h"
#import "MWFSlideNavigationViewController.h"
#import "SSKeychain.h"
#import <QuartzCore/QuartzCore.h>
#import <KrakenKit/KrakenKit.h>

@interface GPMainViewController ()

@property (nonatomic, strong) GPScrollingSegmentedControl *scopeBar;

@property (nonatomic, strong) GPRepositoryListViewController *repositoryTableViewController;

@property (nonatomic, assign) GPAppDelegate *delegate;
@property (nonatomic, strong) GPLoginViewController *loginViewController;
@property (nonatomic, strong) GPNavigationController *loginNavigationBar;
@property (nonatomic, strong) GPNavigationBar *navigationBar;
@property (nonatomic, strong) GPNotificationButton *notificationButton;

@property (nonatomic, strong) NSArray *eventsArray;
@property (nonatomic, strong) UITableView *newsFeedTableView;

@property (nonatomic, strong) CALayer *blanketDimmingLayer;
@property (nonatomic, assign) BOOL loginPresentedOnce;

@end

@implementation GPMainViewController

- (id)init {
	if (self = [super init]) {
		_repositoryTableViewController = [[GPRepositoryListViewController alloc]init];
		
		_delegate = [[UIApplication sharedApplication]delegate];
		
		[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_newLoginSuccessful:) name:GPLoginViewControllerDidSuccessfulyLoginNotification object:nil];
		[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_leftSideActionNotificationRecieved:) name:GPNewsFeedCellSelectedLeftSideActionNotification object:nil];
	
		_blanketDimmingLayer = [[CALayer alloc]init];
		_blanketDimmingLayer.backgroundColor = UIColor.blackColor.CGColor;
		_blanketDimmingLayer.opacity = 0.0;
		_eventsArray = @[];
		
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
        [BWStatusBarOverlay setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
		[[BWStatusBarOverlay shared]setAnimation:BWStatusBarOverlayAnimationTypeFromTop];
	}
	return self;
}

- (void)viewDidLoad {
	    
    CGRect remainder, slice;
	CGRectDivide(self.view.bounds, &slice, &remainder, 44, CGRectMinYEdge);
	self.newsFeedTableView = [[UITableView alloc]initWithFrame:remainder style:UITableViewStylePlain];
	self.newsFeedTableView.delegate = self;
	self.newsFeedTableView.dataSource = self;
	self.newsFeedTableView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
	[self.view addSubview:self.newsFeedTableView];
	
	self.scopeBar = [[GPScrollingSegmentedControl alloc]initWithFrame:slice andItems:@[@"Feed", @"PRs", @"Issues", @"Stars"] inScrollView:self.newsFeedTableView];
	self.scopeBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[self.scopeBar setSelectedSegmentIndex:0];
	
	self.blanketDimmingLayer.frame = self.view.bounds;
	[self.view.layer addSublayer:self.blanketDimmingLayer];
	
	CGRectDivide(self.view.bounds, &slice, &remainder, 300, CGRectMaxXEdge);
	[self.repositoryTableViewController setupWithFrame:slice];
	[self.view addSubview:self.repositoryTableViewController.view];
	[self.repositoryTableViewController hideView];

	self.navigationBar = [[GPNavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
	self.navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[self.view addSubview:self.navigationBar];
	
	CGRectDivide(self.navigationBar.bounds, &slice, &remainder, 42, CGRectMinXEdge);
	self.notificationButton = [[GPNotificationButton alloc]initWithFrame:slice];
	[self.notificationButton addTarget:self action:@selector(revealNotificationsView:) forControlEvents:UIControlEventTouchUpInside];
	self.navigationBar.title = @"News Feed";
	self.navigationBar.label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f];
	[self.navigationBar addSubview:self.notificationButton];
	
}

- (void)viewDidAppear:(BOOL)animated {
	if ([self presentLoginViewControllerIfNeeded]) {
		
	} else {
		if (!self.loginPresentedOnce) {
			[self _reloadSync];
		}
	}
}

- (BOOL)presentLoginViewControllerIfNeeded {
	BOOL result = NO;
	if (!self.loginPresentedOnce) {
		self.currentAccount = [[KRAClient sharedClient]authenticatedUser];
		if (!self.currentAccount) {
			[self _setupLoginViewControllerIfNeeded];
		//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
			[self presentViewController:self.loginNavigationBar animated:YES completion:NULL];
		//#else
		//		[self presentModalViewController:self.loginViewController animated:YES];
		//#endif
		//
			result = YES;
		}
	}
	return result;
	
}

- (void)revealNotificationsView:(id)sender {
	if (self.slideNavigationViewController.currentLandscapeOrientationDistance == 0)
		[self.slideNavigationViewController slideWithDirection:MWFSlideDirectionDown];
	else {
		[self.slideNavigationViewController slideWithDirection:MWFSlideDirectionNone];
	}
}

-(void)_setupLoginViewControllerIfNeeded {
	if (self.loginViewController != nil || self.loginNavigationBar != nil) return;
	
	self.loginViewController = [[GPLoginViewController alloc]init];
	
	self.loginNavigationBar = [[GPNavigationController alloc]initWithRootViewController:self.loginViewController];
	[self.loginNavigationBar setModalPresentationStyle:UIModalPresentationFormSheet];
	self.loginPresentedOnce = YES;
}

-(void)_newLoginSuccessful:(NSNotification*)loginNotification {
	[self dismissViewControllerAnimated:YES completion:NULL];
	self.currentAccount = [[KRAClient sharedClient]authenticatedUser];	
	[[BWStatusBarOverlay shared]showWithMessage:@"Fetching Repositories..." loading:YES animated:YES];
	
//	@weakify(self);
//	[[self.currentAccount syncRepositories]subscribeNext:^(NSArray *repositories) {
//		@strongify(self);
//		[[BWStatusBarOverlay shared]setMessage:@"Fetching News Feed Items..." animated:YES];
//		[self.repositoryTableViewController setAccount:self.currentAccount];
//		[self.repositoryTableViewController setRepositories:repositories];
//		[[self.currentAccount syncNewsFeed]subscribeNext:^(NSArray *events) {
//			@strongify(self);
//			self.eventsArray = events;
//			[self.newsFeedTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
//			[[BWStatusBarOverlay shared]setMessage:@"Loading Events..." animated:YES];
//			
//			[[self.currentAccount syncNotifications]subscribeNext:^(NSArray *events) {
//				NSLog(@"%@", events);
//				[[BWStatusBarOverlay shared]showSuccessWithMessage:@"Finished" duration:2.0 animated:YES];
//			}];
//		}];
//	}];
}

- (void)_reloadSync {	
	[[BWStatusBarOverlay shared]showWithMessage:@"Fetching Repositories..." loading:YES animated:YES];
	
//	@weakify(self);
//	[[self.currentAccount syncRepositories]subscribeNext:^(NSArray *repositories) {
//		@strongify(self);
//		[[BWStatusBarOverlay shared]setMessage:@"Fetching News Feed Items..." animated:YES];
//		[self.repositoryTableViewController setAccount:self.currentAccount];
//		[self.repositoryTableViewController setRepositories:repositories];
//		[[self.currentAccount syncNewsFeed]subscribeNext:^(NSArray *events) {
//			@strongify(self);
//			self.eventsArray = events;
//			[self.newsFeedTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
//			[[BWStatusBarOverlay shared]setMessage:@"Loading Events..." animated:YES];
//			[[self.currentAccount syncNotifications]subscribeNext:^(NSArray *events) {
//				for (KRGithubNotification *notification in events) {
////					if (event.is) {
////						<#statements#>
////					}
//					[self.newsFeedTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
//				}
//				[[BWStatusBarOverlay shared]showSuccessWithMessage:@"Finished" duration:2.0 animated:YES];
//			}];
//		}];
//	}];
}

- (void)_leftSideActionNotificationRecieved:(NSNotification*)notification {
	KRAUser *associatedAccount = notification.userInfo[GPNotificationUserInfoActionObjectKey];
	GPAccountViewController *accountViewController = [[GPAccountViewController alloc]initWithAccount:associatedAccount navigationBar:self.navigationBar];
	[self gp_presentViewController:accountViewController animated:YES newNavigationBar:NO completion:^{
		
	}];
}

#pragma mark - Presentation

- (void)gp_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated newNavigationBar:(BOOL)flag completion:(void (^)(void))completion {
	if (flag) {
		[self presentViewController:viewControllerToPresent animated:animated completion:completion];
	} else {
		viewControllerToPresent.view.frame = CGRectOffset(self.view.bounds, 0, CGRectGetHeight(self.view.bounds));
		[self.view insertSubview:viewControllerToPresent.view belowSubview:self.navigationBar];
		[UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
			CGRect remainder, slice;
			CGRectDivide(self.view.bounds, &slice, &remainder, 44, CGRectMinYEdge);
			viewControllerToPresent.view.frame = remainder;
		} completion:^(BOOL finished) {
			completion();
		}];
	}
}

#pragma mark - Gesture Handling

- (void)handleSwipe:(UISwipeGestureRecognizer*)sender {
	if (sender.direction & UISwipeGestureRecognizerDirectionLeft) {
		[self.repositoryTableViewController showViewAnimated:YES];
		self.blanketDimmingLayer.opacity = 0.8;
		self.newsFeedTableView.userInteractionEnabled = NO;
	}
	if (sender.direction & UISwipeGestureRecognizerDirectionRight) {
		[self.repositoryTableViewController hideViewAnimated:YES];
		self.blanketDimmingLayer.opacity = 0.0;
		self.newsFeedTableView.userInteractionEnabled = YES;
	}
}


#pragma mark - UITableViewDataSource

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *GPNewsFeedCellIdentifier = @"GPNewsFeedCellIdentifier";
	
	GPNewsFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:GPNewsFeedCellIdentifier];
	KRAEvent *event = [self.eventsArray objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[GPNewsFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GPNewsFeedCellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	[cell setEvent:event];
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.eventsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//	if ([(KRAEvent *)[self.eventsArray objectAtIndex:indexPath.row]hasDetail]) {
//		return 145.f;
//	}
	return 50.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

#pragma mark - NPReachability Callback

- (void)_reachabilityHasChanged {
	// TODO Implement
}

@end