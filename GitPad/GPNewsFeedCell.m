//
//  GPNewsFeedCell.m
//  GitPad
//
//  Created by Robert Widmann on 1/10/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "GPNewsFeedCell.h"
#import <KrakenKit.h>

@interface GPNewsFeedCell ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *customFontLabel;
@property (nonatomic, strong) UILabel *detailsLabel;

@end

@implementation GPNewsFeedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
		
		[self addSubview:_label];
		[self addSubview:_customFontLabel];
		[self addSubview:_detailsLabel];

    }
    return self;
}

-(void)setEvent:(KRGithubEvent *)event {
	_event = event;
	[self.label setFont:_fontForEvent(_event)];
	[self.label setText:_titleStringFromEvent(_event)];
	[self.customFontLabel setText:_octiconStringFromEvent(_event)];
	if (self.event.hasDetail) {
		[self.detailsLabel setText:_detailsTextFromEvent(_event)];
	} else {
		[self.detailsLabel setText:@""];
	}
}

- (void)layoutSubviews {
	CGRect remainder, slice;
	if (self.event.hasDetail) {
		CGRectDivide(self.bounds, &slice, &remainder, 50, CGRectMinXEdge);
		slice.size.height = 50.f;
		remainder.size.height = 50.f;
		[self.label setFrame:remainder];
		[self.label setNumberOfLines:2];
		[self.customFontLabel setFont:[UIFont fontWithName:@"octicons" size:36.f]];
		[self.customFontLabel setFrame:slice];
		CGRectDivide(self.bounds, &slice, &remainder, 50, CGRectMinXEdge);
		remainder.size.height -= 50.f;
		remainder.origin.y += 50.f;
		[self.detailsLabel setFrame:remainder];
	} else {
		CGRectDivide(self.bounds, &slice, &remainder, 50, CGRectMinXEdge);
		[self.label setFrame:remainder];
		[self.label setNumberOfLines:1];
		[self.customFontLabel setFont:[UIFont fontWithName:@"octicons" size:16.f]];
		[self.customFontLabel setFrame:slice];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	CGRect b = self.bounds;
	[[UIColor colorWithWhite:0.931 alpha:1.000] set];
	
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(currentContext, 1.f);
    CGContextMoveToPoint(currentContext, 0, CGRectGetHeight(b));
    CGContextAddLineToPoint(currentContext, CGRectGetWidth(b), CGRectGetHeight(b));
    CGContextStrokePath(currentContext);
}

#pragma mark - Private

NSString *_detailsTextFromEvent(KRGithubEvent *event) {
	NSString *detailsText = @"";
	switch (event.eventType) {
		case KRGithubEventPayloadTypeClosedIssue:
		case KRGithubEventPayloadTypeCommentedOnIssue:
		case KRGithubEventPayloadTypeReOpenedIssue:
		case KRGithubEventPayloadTypeOpenedIssue:
			detailsText = event.issue.title;
			break;
		case KRGithubEventPayloadTypePush:
			detailsText = _styledCommits(event.commits);
			break;
		case KRGithubEventPayloadTypeOpenSourcedRepository:
			detailsText = event.repository.descriptionString;
			break;
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
		if (i != 4) {
			[strings addObject:[[commits objectAtIndex:i]descriptionString]];
		} else {
			[strings addObject:@"..."];
		}
	}
	return [strings componentsJoinedByString:@"\n"];
}

NSString *_octiconStringFromEvent(KRGithubEvent *event) {
	NSString *octicon = @"";
	switch (event.eventType) {
		case KRGithubEventPayloadTypeCreatedRepository:
			octicon = @"\uF003";
			break;
		case KRGithubEventPayloadTypeStarred:
			octicon = @"\uF02A";
			break;
		case KRGithubEventPayloadTypeFork:
			octicon = @"\uF020";
			break;
		case KRGithubEventPayloadTypeOpenSourcedRepository:
			octicon = @"\uF001";
			break;
		case KRGithubEventPayloadTypeFollow:
			octicon = @"\uF01C";
			break;
		case KRGithubEventPayloadTypeAddCollaborator:
			octicon = @"\uF01A";
			break;
		case KRGithubEventPayloadTypeOpenedIssue:
			octicon = @"\uF026";
			break;
		case KRGithubEventPayloadTypeReOpenedIssue:
			octicon = @"\uF027";
			break;
		case KRGithubEventPayloadTypeClosedIssue:
			octicon = @"\uF028";
			break;
		case KRGithubEventPayloadTypeCommentedOnIssue:
			octicon = @"\uF229";
			break;
		case KRGithubEventPayloadTypePush:
			octicon = @"\uF205";
		case KRGithubEventPayloadTypeCreatedBranch:
			octicon = @"\uF256";
			break;
		default:
			break;
	}
	return octicon;
}

UIFont *_fontForEvent(KRGithubEvent *event) {
	UIFont *font = [UIFont systemFontOfSize:12.f];
	switch (event.eventType) {
		case KRGithubEventPayloadTypeCreatedRepository:
		case KRGithubEventPayloadTypeStarred:
		case KRGithubEventPayloadTypeFork:
			font = [UIFont fontWithName:@"Helvetica" size:12.f];
			break;
		case KRGithubEventPayloadTypeCreatedBranch:
		case KRGithubEventPayloadTypeCommentedOnIssue:
		case KRGithubEventPayloadTypePush:
		case KRGithubEventPayloadTypeClosedIssue:
		case KRGithubEventPayloadTypeReOpenedIssue:
		case KRGithubEventPayloadTypeOpenedIssue:
		case KRGithubEventPayloadTypeOpenSourcedRepository:
			font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
			break;
		default:
			font = [UIFont fontWithName:@"Helvetica" size:12.f];
			break;
	}
	return font;
}

NSString *_titleStringFromEvent(KRGithubEvent *event) {
	NSString *subject = @"";
	switch (event.eventType) {
		case KRGithubEventPayloadTypeCreatedRepository:
		case KRGithubEventPayloadTypeStarred:
		case KRGithubEventPayloadTypeFork:
		case KRGithubEventPayloadTypeOpenSourcedRepository:
			subject = event.repository.name;
			break;
		case KRGithubEventPayloadTypeFollow:
			subject = event.followee.username;
			break;
		case KRGithubEventPayloadTypeAddCollaborator:
			subject = [NSString stringWithFormat:@"%@ to %@", event.addedMember.username, event.repository.name];
			break;
		case KRGithubEventPayloadTypeOpenedIssue:
		case KRGithubEventPayloadTypeClosedIssue:
		case KRGithubEventPayloadTypeCommentedOnIssue:
			subject = [NSString stringWithFormat:@"%@#%lu", event.repository.name, (unsigned long)event.issue.issueNumber];
			break;
		case KRGithubEventPayloadTypePush:
		case KRGithubEventPayloadTypeCreatedBranch:
			subject = [NSString stringWithFormat:@"%@ at %@", event.repositoryRef.referenceName, event.repository.name];
			break;
		default:
			break;
	}
	return [NSString stringWithFormat:@"%@ %@ %@", event.actor.username, _stringFromEventPayloadType(event.eventType), subject];
}

NSString *_stringFromEventPayloadType(KRGithubEventPayloadType payload) {
	switch (payload) {
		case KRGithubEventPayloadTypeStarred:
			return @"starred";
			break;
		case KRGithubEventPayloadTypeFork:
			return @"forked";
			break;
		case KRGithubEventPayloadTypeFollow:
			return @"started following";
			break;
		case KRGithubEventPayloadTypeAddCollaborator:
			return @"added";
			break;
		case KRGithubEventPayloadTypeCreatedRepository:
			return @"created";
			break;
		case KRGithubEventPayloadTypeCreatedBranch:
			return @"created branch";
			break;
		case KRGithubEventPayloadTypeOpenedIssue:
			return @"opened issue";
			break;
		case KRGithubEventPayloadTypeReOpenedIssue:
			return @"reopened issue";
			break;
		case KRGithubEventPayloadTypeClosedIssue:
			return @"closed issue";
			break;
		case KRGithubEventPayloadTypeCommentedOnIssue:
			return @"commented on issue";
			break;
		case KRGithubEventPayloadTypePush:
			return @"pushed to";
			break;
		case KRGithubEventPayloadTypeOpenSourcedRepository:
			return @"open sourced";
			break;
		default:
			return @"did something else";
			break;
	}
}

@end
