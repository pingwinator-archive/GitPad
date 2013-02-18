//
//  GPRepositoryViewController.m
//  GitPad
//
//  Created by Alex Widmann on 2/17/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "GPRepositoryViewController.h"
#import "GPRepositoryCell.h"
#import "GPNavigationBar.h"
#import <QuartzCore/QuartzCore.h>

@interface GPRepositoryViewController ()

@property (nonatomic, strong) GPNavigationBar *navigationBar;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation GPRepositoryViewController

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
	CGRect remainder, slice;
	CGRectDivide(self.view.superview.bounds, &slice, &remainder, 300, CGRectMaxXEdge);
	[UIView animateWithDuration:0.25 animations:^{
		self.view.frame = slice;
	}];
}

- (void)hideView {
	CGRect hiddenRect = self.view.frame;
	hiddenRect.origin.x = CGRectGetWidth(UIScreen.mainScreen.bounds);
	[UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.view.frame = hiddenRect;
	}completion:^(BOOL finished) {
		
	}];
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
