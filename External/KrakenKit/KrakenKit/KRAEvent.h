//
//  KRAEvent.h
//  KrakenKit
//
//  Created by Robert Widmann on 4/30/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <Mantle/Mantle.h>

typedef NS_ENUM(int, KRAGithubEventType) {
	KRAGithubCommitCommentEventType,
	KRAGithubCreateEventType,
	KRAGithubDeleteEventType,
	KRAGithubDownloadEventType,
	KRAGithubFollowEventType,
	KRAGithubForkEventType,
	KRAGithubForkApplyEventType,
	KRAGithubGistEventType,
	KRAGithubGollumEventType,
	KRAGithubIssueCommentEventType,
	KRAGithubIssuesEventType,
	KRAGithubMemberEventType,
	KRAGithubPublicEventType,
	KRAGithubPullRequestEventType,
	KRAGithubPullRequestReviewCommentEventType,
	KRAGithubPushEventType,
	KRAGithubTeamAddEventType,
	KRAGithubWatchEventType,
};

@class KRARepository, KRAEventPayload, KRAUser;

@interface KRAEvent : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign) KRAGithubEventType type;
@property (nonatomic, copy) NSNumber *isPublic;
@property (nonatomic, copy) KRAEventPayload *payload;
@property (nonatomic, assign) KRARepository *repository;
@property (nonatomic, assign) KRAUser *actor;
@property (nonatomic, assign) KRAUser *organization;
@property (nonatomic, assign) NSDate *createdAt;
@property (nonatomic, assign) NSNumber *eventID;

@end
