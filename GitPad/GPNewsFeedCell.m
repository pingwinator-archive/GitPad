//
//  GPNewsFeedCell.m
//  GitPad
//
//  Created by Robert Widmann on 1/10/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "GPNewsFeedCell.h"
#import "GPUtilities.h"
#import "NSDate+HumanizedTime.h"
#import <KrakenKit/KrakenKit.h>

@interface GPDelineatedView : UIView
@end

@implementation GPDelineatedView
- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	CGRect b = self.bounds;
	[[UIColor colorWithWhite:0.931 alpha:1.000] setStroke];	
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(currentContext, 1.f);
    CGContextMoveToPoint(currentContext, 0, CGRectGetHeight(b));
    CGContextAddLineToPoint(currentContext, CGRectGetWidth(b), CGRectGetHeight(b));
    CGContextStrokePath(currentContext);
}
@end

@interface GPNewsFeedCell ()

@property (nonatomic, strong) GPDelineatedView *topView;

@property (nonatomic, strong) UILabel *dateLabel;
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

	self.backgroundColor = [UIColor colorWithWhite:0.931 alpha:1.000];
	_leftSideActionLabel = [[UILabel alloc]initWithFrame:CGRectZero];
	_leftSideActionLabel.backgroundColor = UIColor.clearColor;
	_leftSideActionLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
	_leftSideActionLabel.font = [UIFont fontWithName:@"GitHub Octicons" size:16.f];
	_leftSideActionLabel.textAlignment = NSTextAlignmentCenter;

	_rightSideActionLabel = [[UILabel alloc]initWithFrame:CGRectZero];
	_rightSideActionLabel.backgroundColor = UIColor.clearColor;
	_rightSideActionLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	_rightSideActionLabel.font = [UIFont fontWithName:@"GitHub Octicons" size:16.f];;
	_rightSideActionLabel.textAlignment = NSTextAlignmentCenter;
	
	_topView = [[GPDelineatedView alloc]initWithFrame:CGRectZero];
	_topView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	_topView.backgroundColor = UIColor.whiteColor;
	
	_dateLabel = [[UILabel alloc]initWithFrame:CGRectZero];
	_dateLabel.backgroundColor = UIColor.clearColor;
	_dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_dateLabel.textColor = [UIColor colorWithWhite:0.678 alpha:1.000];
	_dateLabel.font = [UIFont fontWithName:@"Helvetica" size:12];

	_label = [[UILabel alloc]initWithFrame:CGRectZero];
	_label.backgroundColor = UIColor.clearColor;
	_label.numberOfLines = 1;
	_label.lineBreakMode = NSLineBreakByTruncatingTail;
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
	[_topView addSubview:_dateLabel];

    return self;
}

-(void)setEvent:(KRAEvent *)event {
	_event = event;
	[self.label setFont:_fontForEvent(_event)];
	[self.label setText:_titleStringFromEvent(_event)];
	[self.customFontLabel setText:_octiconStringFromEvent(_event)];
	if (GPEventHasDetail(event)) {
		[self.detailsLabel setText:_detailsTextFromEvent(_event)];
		[self.dateLabel setHidden:NO];
	} else {
		[self.detailsLabel setText:@""];
		[self.dateLabel setHidden:YES];
	}
	[self.dateLabel setText:[event.createdAt stringWithHumanizedTimeDifference:NSDateHumanizedSuffixAgo withFullString:YES].lowercaseString];
	[self.leftSideActionLabel setText:@"\uF018"];
	[self.rightSideActionLabel setText:_rightSideActionTextForEvent(_event)];
}

- (void)layoutSubviews {
	CGRect remainder, slice;
	self.topView.frame = self.bounds;
	if (GPEventHasDetail(self.event)) {
		CGRectDivide(self.bounds, &slice, &remainder, 50, CGRectMinXEdge);
		slice.size.height = 50.f;
		remainder.size.height = 18.f;
		[self.dateLabel setFrame:remainder];
		remainder.origin.y += 18.f;
		[self.label setFrame:remainder];
		[self.label setNumberOfLines:2];
		[self.customFontLabel setFrame:slice];
		CGRectDivide(self.bounds, &slice, &remainder, 50, CGRectMinXEdge);
		remainder.size.height -= 50.f;
		remainder.origin.y += 42.f;
		[self.detailsLabel setFrame:remainder];
		self.customFontLabel.font = [UIFont fontWithName:@"GitHub Octicons" size:36.f];;
	} else {
		CGRectDivide(self.bounds, &slice, &remainder, 50, CGRectMinXEdge);
		[self.label setFrame:remainder];
		[self.label setNumberOfLines:1];
		[self.customFontLabel setFrame:slice];
		self.customFontLabel.font = [UIFont fontWithName:@"GitHub Octicons" size:18.f];;
	}
	CGRectDivide(self.bounds, &slice, &remainder, 50, CGRectMinXEdge);
	[self.leftSideActionLabel setFrame:slice];
	CGRectDivide(self.bounds, &slice, &remainder, 50, CGRectMaxXEdge);
	[self.rightSideActionLabel setFrame:slice];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)handleSwipe:(UISwipeGestureRecognizer*)sender {
	CGRect offsetFrame = self.topView.frame;
	if (sender.direction & UISwipeGestureRecognizerDirectionLeft) {
		offsetFrame = CGRectOffset(self.topView.frame, -50, 0);
	}
	if (sender.direction & UISwipeGestureRecognizerDirectionRight) {
		offsetFrame = CGRectOffset(self.topView.frame, 50, 0);
	}
	[UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.topView.frame = offsetFrame;
	} completion:^(BOOL finished) {
		NSDictionary *userInfo = @{GPNotificationUserInfoSenderKey : self, GPNotificationUserInfoActionKey : @"NewsFeedLeftAction", GPNotificationUserInfoActionObjectKey : self.event.actor};
		[[NSNotificationCenter defaultCenter]postNotificationName:GPNewsFeedCellSelectedLeftSideActionNotification object:nil userInfo:userInfo];
	}];
}

#pragma mark - Private

NSString *_detailsTextFromEvent(KRAEvent *event) {
	NSString *detailsText = @"";
	switch (event.type) {
		case KRAGithubCommitCommentEventType:
		case KRAGithubIssueCommentEventType:
			detailsText = event.payload.comment.body;
			break;
		case KRAGithubPullRequestEventType:
			detailsText = event.payload.pullRequest.title;
			break;
		case KRAGithubIssuesEventType:
			detailsText = event.payload.issue.title;
			break;
		case KRAGithubPushEventType:
			detailsText = _styledCommits(event.payload.commits);
			break;
//		case KRAGithubEventPayloadTypeOpenSourcedRepository:
//			detailsText = event.repository.repoDescription;
//			break;
		default:
			break;

	}
	return detailsText;
}

NSString *_styledCommits(NSArray *commits) {
	NSMutableArray *strings = @[].mutableCopy;
	NSUInteger limit = commits.count;
	if (limit > 4) {
		limit = 4;
	}
	for (int i = 0; i < limit; i++) {
		KRACommit *commit = commits[i];
		if (i == 3) {
			[strings addObject:@"..."];
			continue;
		}
		[strings addObject:[NSString stringWithFormat:@"%@ %@", [commit.sha substringToIndex:7], commit.message]];
	}
	return [strings componentsJoinedByString:@"\n"];
}

NSString *_octiconStringFromEvent(KRAEvent *event) {
	NSString *octicon = @"";
	switch (event.type) {
		case KRAGithubCreateEventType:
			octicon = @"\uf003";
			break;
		case KRAGithubWatchEventType:
			octicon = @"\uF02A";
			break;
		case KRAGithubForkEventType:
			octicon = @"\uf020";
			break;
//		case KRAGithubEventPayloadTypeOpenSourcedRepository:
//			octicon = @"\uF001";
//			break;
//		case KRAGithubEventPayloadTypeFollow:
//			octicon = @"\uF01C";
//			break;
		case KRAGithubMemberEventType:
			octicon = @"\uf01a";
			break;
		case KRAGithubIssuesEventType: {
			switch (event.payload.action) {
				case KRAGithubActionTypeOpened:
					octicon = @"\uf026";
					break;
				case KRAGithubActionTypeClosed:
					octicon = @"\uf028";
					break;
				case KRAGithubActionTypeCreated:
					octicon = @"\uf027";
					break;
				default:
					octicon = @"\uf003";
					break;
			}
		}
			break;
		case KRAGithubCommitCommentEventType:
		case KRAGithubIssueCommentEventType:
			octicon = @"\uf04f";
			break;
		case KRAGithubPushEventType:
			octicon = @"\uf01F";
			break;
		case KRAGithubPullRequestEventType:
			octicon = @"\uf009";
			break;
		case KRAGithubGollumEventType:
			octicon = @"\uf007";
			break;
		default:
			break;
	}
	return octicon;
}

NSString *_rightSideActionTextForEvent(KRAEvent *event) {
	NSString *octicon = @"";
//	switch (event.type) {
//		case KRAGithubEventPayloadTypeStarred:
			octicon = @"\uF001";
//			break;
//		default:
//			break;
//	}
	return octicon;
}

UIFont *_fontForEvent(KRAEvent *event) {
	UIFont *font = [UIFont systemFontOfSize:12.f];
	switch (event.type) {
//		case KRAGithubEventPayloadTypeCreatedRepository:
		case KRAGithubWatchEventType:
		case KRAGithubForkEventType:
			font = [UIFont fontWithName:@"Helvetica" size:12.f];
			break;
		case KRAGithubIssueCommentEventType:
		case KRAGithubCommitCommentEventType:
		case KRAGithubPushEventType:
		case KRAGithubIssuesEventType:
		case KRAGithubCreateEventType:
		case KRAGithubGollumEventType:
		case KRAGithubPullRequestEventType:
			font = [UIFont fontWithName:@"Helvetica-Bold" size:14.f];
			break;
		default:
			font = [UIFont fontWithName:@"Helvetica" size:12.f];
			break;
	}
	return font;
}

NSString *_titleStringFromEvent(KRAEvent *event) {
	NSString *subject = @"";
	switch (event.type) {
		case KRAGithubCreateEventType:
		case KRAGithubForkEventType:
		case KRAGithubPublicEventType:
		case KRAGithubWatchEventType:
			subject = event.repository.name;
			break;
		case KRAGithubTeamAddEventType:
			subject = [NSString stringWithFormat:@"%@ to %@", event.actor.login, event.repository.name];
			break;
		case KRAGithubPullRequestEventType:
			subject = [NSString stringWithFormat:@"%@#%lu", event.repository.name, event.payload.number.unsignedLongValue];
			break;
		case KRAGithubIssuesEventType:
			subject = [NSString stringWithFormat:@"%@#%lu", event.repository.name, event.payload.issue.number.unsignedLongValue];
			break;
		case KRAGithubPushEventType:
			subject = [NSString stringWithFormat:@"%@ at %@", event.payload.ref.lastPathComponent, event.repository.name];
			break;
		case KRAGithubGollumEventType:
			subject = [NSString stringWithFormat:@"%@ wiki", event.repository.name];
			break;
		default:
			break;
	}
	return [NSString stringWithFormat:@"%@ %@ %@", event.actor.login, _stringFromEventPayloadType(event.type, event.payload.action), subject];
}

NSString *_stringFromEventPayloadType(KRAGithubEventType payload, KRAGithubActionType action) {
	switch (payload) {
		case KRAGithubForkEventType:
			return @"forked";
			break;
		case KRAGithubFollowEventType:
			return @"started following";
			break;
		case KRAGithubTeamAddEventType:
			return @"added";
			break;
		case KRAGithubCreateEventType:
			return @"created";
			break;
		case KRAGithubIssuesEventType: {
			switch (action) {
				case KRAGithubActionTypeOpened:
					return @"opened";
					break;
				case KRAGithubActionTypeClosed:
					return @"closed";
					break;
				case KRAGithubActionTypeCreated:
					return @"created";
					break;
				default:
					return @"";
					break;
			}
			return @"issued";
			break;
		}
		case KRAGithubIssueCommentEventType:
			return @"commented on issue";
			break;
		case KRAGithubPushEventType:
			return @"pushed to";
			break;
		case KRAGithubPublicEventType:
			return @"open sourced";
			break;
		case KRAGithubCommitCommentEventType:
			return @"commented on commit";
			break;
		case KRAGithubGollumEventType:
			return @"edited the";
			break;
		case KRAGithubWatchEventType:
			return @"starred";
		case KRAGithubPullRequestEventType: {
			switch (action) {
				case KRAGithubActionTypeOpened:
					return @"opened pull request";
					break;
				case KRAGithubActionTypeClosed:
					return @"merged pull request";
					break;
				case KRAGithubActionTypeCreated:
					return @"merged pull request";
					break;
				default:
					return @"";
					break;
			}
			return @"issued";
			break;
		}
		default:
			return @"did something else";
			break;
	}
}

@end
