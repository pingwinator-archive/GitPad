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

@end

@implementation GPNewsFeedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		_label = [[UILabel alloc]initWithFrame:CGRectZero];
		_label.backgroundColor = UIColor.clearColor;
		[self addSubview:_label];
    }
    return self;
}

-(void)setEvent:(KRGithubEvent *)event {
	_event = event;
	[self.label setFont:_fontForEvent(_event)];
	[self.label setText:_titleStringFromEvent(_event)];
}

- (void)layoutSubviews {
	if (self.event.hasDetail) {
		CGRect remainder, slice;
		CGRectDivide(self.bounds, &slice, &remainder, 50, CGRectMinYEdge);
		[self.label setFrame:CGRectInset(slice, 45, 0)];
	} else {
		[self.label setFrame:CGRectInset(self.bounds, 45, 0)];
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
