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
#import "GPStarredRepoCell.h"
#import "GPRepositoryListViewController.h"
#import "BWStatusBarOverlay.h"
#import "GPScrollingSegmentedControl.h"
#import "SSKeychain.h"
#import "GPLoginTextField.h"
#import "GPUtilities.h"
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
@property (nonatomic, strong) NSArray *starredReposArray;

@property (nonatomic, strong) UITableView *newsFeedTableView;
@property (nonatomic, strong) GPLoginTextField *searchField;

@property (nonatomic, strong) CALayer *blanketDimmingLayer;
@property (nonatomic, assign) BOOL loginPresentedOnce;

@property (nonatomic, strong) UIViewController *currentModalViewController;

@end

@implementation GPMainViewController

- (id)init {
	self = [super init];
		
	_repositoryTableViewController = [[GPRepositoryListViewController alloc]init];
		
	_delegate = [[UIApplication sharedApplication]delegate];
	
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_newLoginSuccessful:) name:GPLoginViewControllerDidSuccessfulyLoginNotification object:nil];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_leftSideActionNotificationRecieved:) name:GPNewsFeedCellSelectedLeftSideActionNotification object:nil];

	_blanketDimmingLayer = [[CALayer alloc]init];
	_blanketDimmingLayer.backgroundColor = UIColor.blackColor.CGColor;
	_blanketDimmingLayer.opacity = 0.0;
	_eventsArray = @[];
	
	[BWStatusBarOverlay setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
	[BWStatusBarOverlay.shared setAnimation:BWStatusBarOverlayAnimationTypeFromTop];

	return self;
}

- (void)viewDidLoad {
	[UIApplication.sharedApplication setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];

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
	
	@weakify(self);
	[[RACAble(self,scopeBar.selectedSegmentIndex) distinctUntilChanged]subscribeNext:^(NSNumber *x) {
		@strongify(self);
		switch (x.intValue) {
			case 0:
				self.navigationBar.title = @"News Feed";
				break;
			case 1:
				self.navigationBar.title = @"Pull Requests";
				break;
			case 2:
				self.navigationBar.title = @"Issues";
				break;
			case 3:
				self.navigationBar.title = @"Stargazers";
				break;
			default:
				break;
		}
		[self.newsFeedTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
	}];
	self.blanketDimmingLayer.frame = self.view.bounds;
	[self.view.layer addSublayer:self.blanketDimmingLayer];
	
//	CGRectDivide(self.view.bounds, &slice, &remainder, 300, CGRectMaxXEdge);
//	[self.repositoryTableViewController setupWithFrame:slice];
//	[self.view addSubview:self.repositoryTableViewController.view];
//	[self.repositoryTableViewController hideView];

	self.navigationBar = [[GPNavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
	self.navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	self.navigationBar.title = @"News Feed";
	self.navigationBar.label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f];
	[self.view addSubview:self.navigationBar];
	
	CGRectDivide(self.navigationBar.bounds, &slice, &remainder, 44, CGRectMinXEdge);
	self.notificationButton = [[GPNotificationButton alloc]initWithFrame:slice];
	self.notificationButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
	[self.notificationButton addTarget:self action:@selector(revealNotificationsView:) forControlEvents:UIControlEventTouchUpInside];
	[RACAble(self,notificationButton.frame) subscribeNext:^(NSValue *x) {
		@strongify(self);
		CGRect frameValue = [x CGRectValue];
		float ratio = frameValue.origin.x  / (CGRectGetWidth(self.view.bounds) - 44);
		[self.searchField setAlpha:ratio];
		[self.blanketDimmingLayer setOpacity:ratio/2];
	}];
	[self.navigationBar addSubview:self.notificationButton];
	
	CGRectDivide(self.navigationBar.bounds, &slice, &remainder, 64, CGRectMaxXEdge);
	remainder.origin.x += 10;
	remainder.size.height -= 10;
	remainder.origin.y += 5;
	self.searchField = [[GPLoginTextField alloc]initWithFrame:remainder];
	self.searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	self.searchField.placeholder = @"Search or type a command";
	self.searchField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	self.searchField.backgroundColor = UIColor.whiteColor;
	self.searchField.alpha = 0;
	self.notificationButton.searchField = self.searchField;
	[self.navigationBar addSubview:self.searchField];
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	
	self.blanketDimmingLayer.frame = self.view.bounds;
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
//			[self presentViewController:self.loginNavigationBar animated:YES completion:NULL];
		//#else
			self.loginViewController.modalPresentationStyle = UIModalPresentationFormSheet;
			[self presentModalViewController:self.loginViewController animated:YES];
		//#endif
		//
			result = YES;
		}
	}
	return result;
	
}

- (void)revealNotificationsView:(id)sender {

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
	
	@weakify(self);
	[KRAClient.sharedClient repositoriesForUser:self.currentAccount completion:^(NSArray *repositories, NSError *error) {
		@strongify(self);
		[[BWStatusBarOverlay shared]setMessage:@"Fetching News Feed Items..." animated:YES];
		[self.repositoryTableViewController setAccount:self.currentAccount];
		[self.repositoryTableViewController setRepositories:repositories];
		[KRAClient.sharedClient eventsForUser:self.currentAccount completion:^(NSArray *events, NSError *error) {
			self.eventsArray = events;
			[self.newsFeedTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
			[[BWStatusBarOverlay shared]showSuccessWithMessage:@"Finished" duration:2.0 animated:YES];
		}];
		[KRAClient.sharedClient starredRepositoriesForUser:self.currentAccount completion:^(NSArray *starredRepos, NSError *error) {
			self.starredReposArray = starredRepos;
		}];
	}];
}

- (void)_reloadSync {	
	[[BWStatusBarOverlay shared]showWithMessage:@"Fetching Repositories..." loading:YES animated:YES];
	@weakify(self);
	[KRAClient.sharedClient repositoriesForUser:self.currentAccount completion:^(NSArray *repositories, NSError *error) {
		@strongify(self);
		[[BWStatusBarOverlay shared]setMessage:@"Fetching News Feed Items..." animated:YES];
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
	}];

}

- (void)_leftSideActionNotificationRecieved:(NSNotification*)notification {
	KRAUser *associatedAccount = notification.userInfo[GPNotificationUserInfoActionObjectKey];
	GPAccountViewController *accountViewController = [[GPAccountViewController alloc]initWithAccount:associatedAccount presentingViewController:self];
	[self gp_presentViewController:accountViewController animated:YES newNavigationBar:NO completion:^{
		
	}];
}

#pragma mark - Presentation

- (void)gp_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated newNavigationBar:(BOOL)flag completion:(void (^)(void))completion {
	self.currentModalViewController = viewControllerToPresent;
	if (flag) {
		[self presentViewController:viewControllerToPresent animated:animated completion:completion];
	} else {
		viewControllerToPresent.view.frame = CGRectOffset(self.view.bounds, 0, CGRectGetHeight(self.view.bounds));
		viewControllerToPresent.view.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
		[self.view addSubview:viewControllerToPresent.view];
		[UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
			CGRect remainder, slice;
			CGRectDivide(self.view.bounds, &slice, &remainder, 22, CGRectMinYEdge);
			viewControllerToPresent.view.frame = self.view.bounds;
		} completion:^(BOOL finished) {
			completion();
		}];
	}
}

- (void)gp_dismissCurrentViewController {
	[self.newsFeedTableView reloadData];
	@weakify(self);
	[UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
		@strongify(self);
		self.currentModalViewController.view.frame = CGRectOffset(self.view.bounds, 0, CGRectGetHeight(self.view.bounds));
	} completion:^(BOOL finished) {
		@strongify(self);
		[self.currentModalViewController.view removeFromSuperview];
		self.currentModalViewController = nil;
	}];
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
	static NSString *GPStarredCellIdentifier = @"GPStarredCellIdentifier";

	UITableViewCell *cell = nil;
	switch (self.scopeBar.selectedSegmentIndex) {
		case 0: {
			cell = [tableView dequeueReusableCellWithIdentifier:GPNewsFeedCellIdentifier];
			KRAEvent *event = [self.eventsArray objectAtIndex:indexPath.row];
			if (!cell || ![cell isKindOfClass:GPNewsFeedCell.class]) {
				cell = [[GPNewsFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GPNewsFeedCellIdentifier];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			[(GPNewsFeedCell*)cell setEvent:event];
		}
			break;
		case 1:
		case 2:
		case 3: {
			cell = [tableView dequeueReusableCellWithIdentifier:GPStarredCellIdentifier];
			KRARepository *repo = [self.starredReposArray objectAtIndex:indexPath.row];
			if (!cell || ![cell isKindOfClass:GPStarredRepoCell.class]) {
				cell = [[GPStarredRepoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GPNewsFeedCellIdentifier];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			[(GPStarredRepoCell*)cell setRepository:repo];
		}
		default:
			break;
	}
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (self.scopeBar.selectedSegmentIndex) {
		case 0:
			return self.eventsArray.count;
			break;
		case 1:
		case 2:
		case 3:
			return self.starredReposArray.count;
			break;
		default:
			break;
	}
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (self.scopeBar.selectedSegmentIndex) {
		case 0: {
			if (GPEventHasDetail([self.eventsArray objectAtIndex:indexPath.row])) {
				return 100.f;
			}
			return 50.f;
		}
			break;
		case 1:
		case 2:
		case 3:
			return 70.f;
			break;
		default:
			break;
	}
	return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

#pragma mark - NPReachability Callback

- (void)_reachabilityHasChanged {
	// TODO Implement
}

@end