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
#import "GPConstants.h"
#import "GPRepositoryViewController.h"
#import <KrakenKit/KrakenKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GPMainViewController ()

@property (nonatomic, strong) GPRepositoryViewController *repositoryTableViewController;

@property (nonatomic, assign) GPAppDelegate *delegate;
@property (nonatomic, strong) GPLoginViewController *loginViewController;
@property (nonatomic, strong) GPNavigationController *loginNavigationBar;
@property (nonatomic, strong) GPNavigationBar *navigationBar;
@property (nonatomic, strong) GPNotificationButton *notificationButton;

@property (nonatomic, strong) NSArray *eventsArray;
@property (nonatomic, strong) UITableView *newsFeedTableView;

@property (nonatomic, strong) UISwipeGestureRecognizer *repoViewPanGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *repoViewPanGestureRecognizer2;

@property (nonatomic, strong) CALayer *blanketDimmingLayer;

@end

@implementation GPMainViewController

- (id)init {
	if (self = [super init]) {
		_repositoryTableViewController = [[GPRepositoryViewController alloc]init];
		
		_delegate = [[UIApplication sharedApplication]delegate];
		
		[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_newLoginSuccessful:) name:GPLoginViewControllerDidSuccessfulyLoginNotification object:nil];
		self.repoViewPanGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
		self.repoViewPanGestureRecognizer.direction = (UISwipeGestureRecognizerDirectionRight);
		
		self.repoViewPanGestureRecognizer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
		self.repoViewPanGestureRecognizer2.direction = (UISwipeGestureRecognizerDirectionLeft);
		
		_blanketDimmingLayer = [[CALayer alloc]init];
		_blanketDimmingLayer.backgroundColor = UIColor.blackColor.CGColor;
		_blanketDimmingLayer.opacity = 0.0;
		
		_eventsArray = @[];
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
	self.navigationBar.title = @"News Feed";
	self.navigationBar.label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f];
	[self.navigationBar addSubview:self.notificationButton];
	
	CGRectDivide(self.view.bounds, &slice, &remainder, 44, CGRectMinYEdge);
	self.newsFeedTableView = [[UITableView alloc]initWithFrame:remainder style:UITableViewStylePlain];
	self.newsFeedTableView.delegate = self;
	self.newsFeedTableView.dataSource = self;
	[self.view addSubview:self.newsFeedTableView];
	
	self.blanketDimmingLayer.frame = self.view.bounds;
	[self.view.layer addSublayer:self.blanketDimmingLayer];
	
	CGRectDivide(self.view.bounds, &slice, &remainder, 300, CGRectMaxXEdge);
	[self.repositoryTableViewController setupWithFrame:slice];
	[self.repositoryTableViewController hideView];
	[self.view addSubview:self.repositoryTableViewController.view];
	
	[self.view addGestureRecognizer:self.repoViewPanGestureRecognizer];
	[self.view addGestureRecognizer:self.repoViewPanGestureRecognizer2];
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

-(void)_newLoginSuccessful:(NSNotification*)loginNotification {
	[self dismissViewControllerAnimated:YES completion:NULL];
	KRGithubAccount *account = loginNotification.object;
	@weakify(self);
	[[account syncRepositories]subscribeNext:^(NSArray *repositories) {
		@strongify(self);
		[self.repositoryTableViewController setAccount:account];
		[self.repositoryTableViewController setRepositories:repositories];
	}];
	[[account syncNewsFeed]subscribeNext:^(NSArray *events) {
		@strongify(self);
		self.eventsArray = events;
		[self.newsFeedTableView reloadData];
	}];
}

#pragma mark - Gesture Handling

- (void)handleSwipe:(UISwipeGestureRecognizer*)sender {
	if (sender.direction & UISwipeGestureRecognizerDirectionLeft) {
		[self.repositoryTableViewController showView];
		self.blanketDimmingLayer.opacity = 0.8;
		self.newsFeedTableView.userInteractionEnabled = NO;
	}
	if (sender.direction & UISwipeGestureRecognizerDirectionRight) {
		[self.repositoryTableViewController hideView];
		self.blanketDimmingLayer.opacity = 0.0;
		self.newsFeedTableView.userInteractionEnabled = YES;
	}
}


#pragma mark - UITableViewDataSource

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *GPNewsFeedCellIdentifier = @"GPNewsFeedCellIdentifier";
	
	GPNewsFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:GPNewsFeedCellIdentifier];
	KRGithubEvent *event = [self.eventsArray objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[GPNewsFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GPNewsFeedCellIdentifier];
    }
	[cell setEvent:event];
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.eventsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([[self.eventsArray objectAtIndex:indexPath.row]hasDetail]) {
		return 145.f;
	}
	return 50.f;
}

@end
