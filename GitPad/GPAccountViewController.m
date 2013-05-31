//
//  GPAccountViewController.m
//  GitPad
//
//  Created by Alex Widmann on 2/18/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "GPAccountViewController.h"
#import "GPNavigationBar.h"
#import "GPScrollingSegmentedControl.h"
#import "GPProfileContainerView.h"
#import "GPMainViewController.h"

@interface GPAccountContainerView : UIView

@property (nonatomic, strong) GPScrollingSegmentedControl *scopeBar;
@property (nonatomic, strong) GPProfileContainerView *profileContainerView;

@end

@implementation GPAccountContainerView

- (id)initWithFrame:(CGRect)frame andAccount:(KRAUser *)account{
	self = [super initWithFrame:frame];
	
	_scopeBar = [[GPScrollingSegmentedControl alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 44) andItems:@[@"Profile", @"Repos", @"Activity"] inScrollView:nil];
	_scopeBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[_scopeBar setSelectedSegmentIndex:0];
	[self addSubview:_scopeBar];
	
	_profileContainerView = [[GPProfileContainerView alloc]initWithFrame:CGRectZero andAccount:account];
	[self addSubview:_profileContainerView];
	
	return self;
}

- (void)layoutSubviews {
	CGRect remainder, slice;
	CGRectDivide(self.bounds, &slice, &remainder, 44, CGRectMinYEdge);
	self.scopeBar.frame = slice;
	
	self.profileContainerView.frame = remainder;
}

@end

@interface GPAccountViewController ()

@property (nonatomic, strong) KRAUser *account;
@property (nonatomic, strong) GPNavigationBar *navigationbar;
@property (nonatomic, strong) UISwipeGestureRecognizer *dismissSwipeGestureRecognizer;
@property (nonatomic, weak) UIViewController *presentingVC;

@end

@implementation GPAccountViewController

- (id)initWithAccount:(KRAUser *)account navigationBar:(GPNavigationBar *)navigationBar presentingViewController:(UIViewController *)presentingViewController {
	self = [super init];
	
	_account = account;
	_navigationbar = navigationBar;
	_presentingVC = presentingViewController;
	
	_dismissSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
	_dismissSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
	[self.view addGestureRecognizer:_dismissSwipeGestureRecognizer];
	
	return self;
}

- (void)loadView {
	GPAccountContainerView *view = [[GPAccountContainerView alloc]initWithFrame:CGRectZero andAccount:self.account];
	view.backgroundColor = UIColor.whiteColor;
	self.view = view;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationbar setTitle:@"Profile"];
}

- (void)dismiss {
	[(GPMainViewController *)self.presentingVC gp_dismissCurrentViewController];
}


@end
