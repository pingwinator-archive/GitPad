//
//  GPRepositoryViewController.m
//  GitPad
//
//  Created by Alex Widmann on 2/17/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "GPRepositoryListViewController.h"
#import "GPRepositoryCell.h"
#import "GPNavigationBar.h"
#import <QuartzCore/QuartzCore.h>

@interface GPRepositoryListViewController ()

@property (nonatomic, strong) GPNavigationBar *navigationBar;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation GPRepositoryListViewController

- (id)init {
	self = [super init];
	
	return self;
}

- (void)loadView {
	[super loadView];
	self.view = [[UIView alloc]initWithFrame:CGRectZero];
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin);
	
	UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
	tableView.delegate = self;
	tableView.dataSource = self;
	self.tableView = tableView;
	[self.view addSubview:self.tableView];
	
	self.navigationBar = [[GPNavigationBar alloc]initWithFrame:CGRectZero];
	self.navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	self.navigationBar.label.textAlignment = NSTextAlignmentLeft;
	[self.view addSubview:self.navigationBar];
	
	self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectZero];
	[self.view addSubview:self.searchBar];
}

- (void)setupWithFrame:(CGRect)frame {
	[self.view setFrame:frame];
	
	CGRect remainder, slice;
	CGRectDivide(self.view.bounds, &slice, &remainder, 44, CGRectMinYEdge);
	CGRect searchBarFrame = remainder;
	searchBarFrame.size.height = 44;
	self.searchBar.frame = searchBarFrame;
	self.navigationBar.frame = slice;
	
	CGRectDivide(self.view.bounds, &slice, &remainder, 88, CGRectMinYEdge);
	[self.tableView setFrame:remainder];

	CGRect labelFrame = self.navigationBar.label.frame;
	labelFrame = CGRectInset(labelFrame, 12, 0);
	self.navigationBar.label.frame = labelFrame;
}

- (void)showView {
	[self showViewAnimated:NO];

}

- (void)hideView {
	[self hideViewAnimated:NO];
}

- (void)showViewAnimated:(BOOL)animated {
	CGRect remainder, slice;
	CGRectDivide(self.view.superview.bounds, &slice, &remainder, 300, CGRectMaxXEdge);
	if (animated) {
		[UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
			self.view.frame = slice;
		} completion:^(BOOL finished) {
			
		}];
	}else {
		self.view.frame = slice;
	}
}

- (void)hideViewAnimated:(BOOL)animated {
	CGRect hiddenRect = self.view.frame;
	hiddenRect.origin.x = CGRectGetWidth(self.view.superview.bounds);
	if (animated) {
		[UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
			self.view.frame = hiddenRect;
		} completion:^(BOOL finished) {
			
		}];
	} else {
		self.view.frame = hiddenRect;
	}
}

- (void)setRepositories:(NSArray *)repositories {
	_repositories = repositories;
	self.navigationBar.title = [NSString stringWithFormat:@"Your Repositories (%lu)", (unsigned long)repositories.count];
	[self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *GPNewsFeedCellIdentifier = @"GPNewsFeedCellIdentifier";
	
	GPRepositoryCell *cell = [tableView dequeueReusableCellWithIdentifier:GPNewsFeedCellIdentifier];
    if (cell == nil) {
		KRGithubRepository *repo = [self.repositories objectAtIndex:indexPath.row];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = [[GPRepositoryCell alloc] initWithRepository:repo style:UITableViewCellStyleDefault reuseIdentifier:GPNewsFeedCellIdentifier];
    }
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.repositories.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 32.f;
}

#pragma mark - Private


@end
