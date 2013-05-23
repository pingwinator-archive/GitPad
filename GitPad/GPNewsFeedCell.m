//
//  GPNewsFeedCell.m
//  GitPad
//
//  Created by Robert Widmann on 1/10/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "GPNewsFeedCell.h"

@interface GPNewsFeedCell ()

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *customFontLabel;
@property (nonatomic, strong) UILabel *detailsLabel;

@property (nonatomic, strong) UILabel *leftSideActionLabel;
@property (nonatomic, strong) UILabel *rightSideActionLabel;

@property (nonatomic, strong) UISwipeGestureRecognizer *repoViewPanGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *repoViewPanGestureRecognizer2;
@end

@implementation GPNewsFeedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		_leftSideActionLabel = [[UILabel alloc]initWithFrame:CGRectZero];
		_leftSideActionLabel.backgroundColor = UIColor.clearColor;
		_leftSideActionLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
		_leftSideActionLabel.font = [UIFont fontWithName:@"octicons" size:16.f];
		_leftSideActionLabel.textAlignment = NSTextAlignmentCenter;

		_rightSideActionLabel = [[UILabel alloc]initWithFrame:CGRectZero];
		_rightSideActionLabel.backgroundColor = UIColor.clearColor;
		_rightSideActionLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		_rightSideActionLabel.font = [UIFont fontWithName:@"octicons" size:16.f];
		_rightSideActionLabel.textAlignment = NSTextAlignmentCenter;
		
		_topView = [[UIView alloc]initWithFrame:CGRectZero];
		_topView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		_topView.backgroundColor = UIColor.whiteColor;
		
		_label = [[UILabel alloc]initWithFrame:CGRectZero];
		_label.backgroundColor = UIColor.clearColor;
		_label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		_customFontLabel = [[UILabel alloc]initWithFrame:CGRectZero];
		_customFontLabel.textAlignment = NSTextAlignmentCenter;
		_customFontLabel.backgroundColor = UIColor.clearColor;
		_customFontLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
		
		_detailsLabel = [[UILabel alloc]initWithFrame:CGRectZero];
		_detailsLabel.backgroundColor = UIColor.clearColor;
		_detailsLabel.numberOfLines = 4;
		_detailsLabel.lineBreakMode = NSLineBreakByTruncatingTail;
		_detailsLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
		_detailsLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
		
		self.repoViewPanGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
		self.repoViewPanGestureRecognizer.direction = (UISwipeGestureRecognizerDirectionRight);
		
		self.repoViewPanGestureRecognizer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
		self.repoViewPanGestureRecognizer2.direction = (UISwipeGestureRecognizerDirectionLeft);
		[_topView addGestureRecognizer:self.repoViewPanGestureRecognizer];
		[_topView addGestureRecognizer:self.repoViewPanGestureRecognizer2];

		[self addSubview:_leftSideActionLabel];
		[self addSubview:_rightSideActionLabel];
		[self addSubview:_topView];
		[_topView addSubview:_label];
		[_topView addSubview:_customFontLabel];
		[_topView addSubview:_detailsLabel];

    }
    return self;
}

//-(void)setEvent:(KRAEvent *)event {
//	_event = event;
//	[self.label setFont:_fontForEvent(_event)];
//	[self.label setText:_titleStringFromEvent(_event)];
//	[self.customFontLabel setText:_octiconStringFromEvent(_event)];
//	if (self.event.hasDetail) {
//		[self.detailsLabel setText:_detailsTextFromEvent(_event)];
//	} else {
//		[self.detailsLabel setText:@""];
//	}
//	[self.leftSideActionLabel setText:@"\uF018"];
//	[self.rightSideActionLabel setText:_rightSideActionTextForEvent(_event)];
//}
//
//- (void)layoutSubviews {
//	CGRect remainder, slice;
//	self.topView.frame = self.bounds;
//	if (self.event.hasDetail) {
//		CGRectDivide(self.bounds, &slice, &remainder, 50, CGRectMinXEdge);
//		slice.size.height = 50.f;
//		remainder.size.height = 50.f;
//		[self.label setFrame:remainder];
//		[self.label setNumberOfLines:2];
//		[self.customFontLabel setFont:[UIFont fontWithName:@"octicons" size:36.f]];
//		[self.customFontLabel setFrame:slice];
//		CGRectDivide(self.bounds, &slice, &remainder, 50, CGRectMinXEdge);
//		remainder.size.height -= 50.f;
//		remainder.origin.y += 50.f;
//		[self.detailsLabel setFrame:remainder];
//	} else {
//		CGRectDivide(self.bounds, &slice, &remainder, 50, CGRectMinXEdge);
//		[self.label setFrame:remainder];
//		[self.label setNumberOfLines:1];
//		[self.customFontLabel setFont:[UIFont fontWithName:@"octicons" size:16.f]];
//		[self.customFontLabel setFrame:slice];
//	}
//	CGRectDivide(self.bounds, &slice, &remainder, 50, CGRectMinXEdge);
//	[self.leftSideActionLabel setFrame:slice];
//	CGRectDivide(self.bounds, &slice, &remainder, 50, CGRectMaxXEdge);
//	[self.rightSideActionLabel setFrame:slice];
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
//
//- (void)handleSwipe:(UISwipeGestureRecognizer*)sender {
//	CGRect offsetFrame = self.topView.frame;
//	if (sender.direction & UISwipeGestureRecognizerDirectionLeft) {
//		offsetFrame = CGRectOffset(self.topView.frame, -50, 0);
//	}
//	if (sender.direction & UISwipeGestureRecognizerDirectionRight) {
//		offsetFrame = CGRectOffset(self.topView.frame, 50, 0);
//	}
//	[UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
//		self.topView.frame = offsetFrame;
//	} completion:^(BOOL finished) {
//		NSDictionary *userInfo = @{GPNotificationUserInfoSenderKey : self, GPNotificationUserInfoActionKey : @"NewsFeedLeftAction", GPNotificationUserInfoActionObjectKey : self.event.actor};
//		[[NSNotificationCenter defaultCenter]postNotificationName:GPNewsFeedCellSelectedLeftSideActionNotification object:nil userInfo:userInfo];
//	}];
//}
//
//- (void)drawRect:(CGRect)rect {
//	[super drawRect:rect];
//	
//	CGRect b = self.bounds;
//	[[UIColor colorWithWhite:0.931 alpha:1.000] set];
//	UIRectFill(rect);
//
//    CGContextRef currentContext = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(currentContext, 1.f);
//    CGContextMoveToPoint(currentContext, 0, CGRectGetHeight(b));
//    CGContextAddLineToPoint(currentContext, CGRectGetWidth(b), CGRectGetHeight(b));
//    CGContextStrokePath(currentContext);
//}
//
//#pragma mark - Private
//
//NSString *_detailsTextFromEvent(KRAEvent *event) {
//	NSString *detailsText = @"";
//	switch (event.eventType) {
//		case KRAGithubEventPayloadTypeClosedIssue:
//		case KRAGithubEventPayloadTypeCommentedOnIssue:
//		case KRAGithubEventPayloadTypeReOpenedIssue:
//		case KRAGithubEventPayloadTypeOpenedIssue:
//			detailsText = event.issue.title;
//			break;
//		case KRAGithubEventPayloadTypePush:
//			detailsText = _styledCommits(event.commits);
//			break;
//		case KRAGithubEventPayloadTypeOpenSourcedRepository:
//			detailsText = event.repository.descriptionString;
//			break;
//		default:
//			break;
//
//	}
//	return detailsText;
//}
//
//NSString *_styledCommits(NSArray *commits) {
//	NSMutableArray *strings = @[].mutableCopy;
//	NSUInteger limit = commits.count;
//	if (limit > 4) {
//		limit = 4;
//	}
//	for (int i = 0; i < limit; i++) {
//		if (i != 4) {
//			[strings addObject:[[commits objectAtIndex:i]descriptionString]];
//		} else {
//			[strings addObject:@"..."];
//		}
//	}
//	return [strings componentsJoinedByString:@"\n"];
//}
//
//NSString *_octiconStringFromEvent(KRAEvent *event) {
//	NSString *octicon = @"";
//	switch (event.eventType) {
//		case KRAGithubEventPayloadTypeCreatedRepository:
//			octicon = @"\uF003";
//			break;
//		case KRAGithubEventPayloadTypeStarred:
//			octicon = @"\uF02A";
//			break;
//		case KRAGithubEventPayloadTypeFork:
//			octicon = @"\uF020";
//			break;
//		case KRAGithubEventPayloadTypeOpenSourcedRepository:
//			octicon = @"\uF001";
//			break;
//		case KRAGithubEventPayloadTypeFollow:
//			octicon = @"\uF01C";
//			break;
//		case KRAGithubEventPayloadTypeAddCollaborator:
//			octicon = @"\uF01A";
//			break;
//		case KRAGithubEventPayloadTypeOpenedIssue:
//			octicon = @"\uF026";
//			break;
//		case KRAGithubEventPayloadTypeReOpenedIssue:
//			octicon = @"\uF027";
//			break;
//		case KRAGithubEventPayloadTypeClosedIssue:
//			octicon = @"\uF028";
//			break;
//		case KRAGithubEventPayloadTypeCommentedOnIssue:
//			octicon = @"\uF229";
//			break;
//		case KRAGithubEventPayloadTypePush:
//			octicon = @"\uF01F";
//			break;
//		case KRAGithubEventPayloadTypeCreatedBranch:
//			octicon = @"\uF256";
//			break;
//		default:
//			break;
//	}
//	return octicon;
//}
//
//NSString *_rightSideActionTextForEvent(KRAEvent *event) {
//	NSString *octicon = @"";
//	switch (event.eventType) {
//		case KRAGithubEventPayloadTypeStarred:
//			octicon = @"\uF001";
//			break;
//		default:
//			break;
//	}
//	return octicon;
//}
//
//UIFont *_fontForEvent(KRAEvent *event) {
//	UIFont *font = [UIFont systemFontOfSize:12.f];
//	switch (event.eventType) {
//		case KRAGithubEventPayloadTypeCreatedRepository:
//		case KRAGithubEventPayloadTypeStarred:
//		case KRAGithubEventPayloadTypeFork:
//			font = [UIFont fontWithName:@"Helvetica" size:12.f];
//			break;
//		case KRAGithubEventPayloadTypeCreatedBranch:
//		case KRAGithubEventPayloadTypeCommentedOnIssue:
//		case KRAGithubEventPayloadTypePush:
//		case KRAGithubEventPayloadTypeClosedIssue:
//		case KRAGithubEventPayloadTypeReOpenedIssue:
//		case KRAGithubEventPayloadTypeOpenedIssue:
//		case KRAGithubEventPayloadTypeOpenSourcedRepository:
//			font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
//			break;
//		default:
//			font = [UIFont fontWithName:@"Helvetica" size:12.f];
//			break;
//	}
//	return font;
//}
//
//NSString *_titleStringFromEvent(KRAEvent *event) {
//	NSString *subject = @"";
//	switch (event.eventType) {
//		case KRAGithubEventPayloadTypeCreatedRepository:
//		case KRAGithubEventPayloadTypeStarred:
//		case KRAGithubEventPayloadTypeFork:
//		case KRAGithubEventPayloadTypeOpenSourcedRepository:
//			subject = event.repository.name;
//			break;
//		case KRAGithubEventPayloadTypeFollow:
//			subject = event.followee.username;
//			break;
//		case KRAGithubEventPayloadTypeAddCollaborator:
//			subject = [NSString stringWithFormat:@"%@ to %@", event.addedMember.username, event.repository.name];
//			break;
//		case KRAGithubEventPayloadTypeOpenedIssue:
//		case KRAGithubEventPayloadTypeClosedIssue:
//		case KRAGithubEventPayloadTypeCommentedOnIssue:
//			subject = [NSString stringWithFormat:@"%@#%lu", event.repository.name, (unsigned long)event.issue.issueNumber];
//			break;
//		case KRAGithubEventPayloadTypePush:
//		case KRAGithubEventPayloadTypeCreatedBranch:
//			subject = [NSString stringWithFormat:@"%@ at %@", event.repositoryRef.referenceName, event.repository.name];
//			break;
//		default:
//			break;
//	}
//	return [NSString stringWithFormat:@"%@ %@ %@", event.actor.username, _stringFromEventPayloadType(event.eventType), subject];
//}
//
//NSString *_stringFromEventPayloadType(KRAGithubEventType payload) {
//	switch (payload) {
//		case KRAGithubEventPayloadTypeStarred:
//			return @"starred";
//			break;
//		case KRAGithubEventPayloadTypeFork:
//			return @"forked";
//			break;
//		case KRAGithubEventPayloadTypeFollow:
//			return @"started following";
//			break;
//		case KRAGithubEventPayloadTypeAddCollaborator:
//			return @"added";
//			break;
//		case KRAGithubEventPayloadTypeCreatedRepository:
//			return @"created";
//			break;
//		case KRAGithubEventPayloadTypeCreatedBranch:
//			return @"created branch";
//			break;
//		case KRAGithubEventPayloadTypeOpenedIssue:
//			return @"opened issue";
//			break;
//		case KRAGithubEventPayloadTypeReOpenedIssue:
//			return @"reopened issue";
//			break;
//		case KRAGithubEventPayloadTypeClosedIssue:
//			return @"closed issue";
//			break;
//		case KRAGithubEventPayloadTypeCommentedOnIssue:
//			return @"commented on issue";
//			break;
//		case KRAGithubEventPayloadTypePush:
//			return @"pushed to";
//			break;
//		case KRAGithubEventPayloadTypeOpenSourcedRepository:
//			return @"open sourced";
//			break;
//		default:
//			return @"did something else";
//			break;
//	}
//}

@end
