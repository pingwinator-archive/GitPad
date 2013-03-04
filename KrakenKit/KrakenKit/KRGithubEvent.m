//
//  KRGithubEvent.m
//  KrakenKit
//
//  Created by Alex Widmann on 2/17/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "KRGithubEvent.h"
#import "KRGithubAccount.h"
#import "KRGithubRepository.h"
#import "KRGithubIssue.h"
#import "KRGithubCommit.h"

@implementation KRGithubEvent


- (id)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	
	NSDictionary *actorDictionary = dictionary[@"actor"];
	if (actorDictionary != nil) {
		_actor = [KRGithubAccount accountWithDictionary:actorDictionary];
	}
	NSDictionary *repoDictionary = dictionary[@"repo"];
	if (repoDictionary != nil) {
		_repository = [[KRGithubRepository alloc]initWithDictionary:repoDictionary];
	}
	NSDictionary *payloadDictionary = dictionary[@"payload"];
	if (payloadDictionary != nil) {
		if ([payloadDictionary[@"action"] isEqualToString:@"started"]) {
			_eventType = KRGithubEventPayloadTypeStarred; 
		} else if ([payloadDictionary[@"action"] isEqualToString:@"opened"]) {
			_eventType = KRGithubEventPayloadTypeOpenedIssue;
			_issue = [[KRGithubIssue alloc]initWithDictionary:payloadDictionary[@"issue"]];
		} else if ([payloadDictionary[@"action"] isEqualToString:@"reopened"]) {
			_eventType = KRGithubEventPayloadTypeReOpenedIssue;
			_issue = [[KRGithubIssue alloc]initWithDictionary:payloadDictionary[@"issue"]];
		} else if ([payloadDictionary[@"action"] isEqualToString:@"added"]) {
			_eventType = KRGithubEventPayloadTypeAddCollaborator;
			_addedMember = [KRGithubAccount accountWithDictionary:payloadDictionary[@"member"]];
		} else if ([payloadDictionary[@"action"] isEqualToString:@"closed"]) {
			_issue = [[KRGithubIssue alloc]initWithDictionary:payloadDictionary[@"issue"]];
			_eventType = KRGithubEventPayloadTypeClosedIssue;
		} else if ([payloadDictionary[@"action"] isEqualToString:@"created"] || [dictionary[@"type"]isEqualToString:@"PullRequestReviewCommentEvent"]) {
			_issue = [[KRGithubIssue alloc]initWithDictionary:payloadDictionary[@"issue"]];
			_eventType = KRGithubEventPayloadTypeCommentedOnIssue;
		} else if (payloadDictionary[@"forkee"] != nil) {
			_eventType = KRGithubEventPayloadTypeFork;
		} else if (payloadDictionary[@"target"] != nil) {
			_eventType = KRGithubEventPayloadTypeFollow;
			_followee = [KRGithubAccount accountWithDictionary:payloadDictionary[@"target"]];
		} else if ([payloadDictionary[@"ref_type"]isEqualToString:@"repository"]) {
			_eventType = KRGithubEventPayloadTypeCreatedRepository;
			_repositoryRef = [[KRGithubRepositoryReference alloc]initWithDictionary:payloadDictionary];
		} else if ([payloadDictionary[@"ref_type"]isEqualToString:@"branch"]) {
			_eventType = KRGithubEventPayloadTypeCreatedBranch;
			_repositoryRef = [[KRGithubRepositoryReference alloc]initWithDictionary:payloadDictionary];
		} else if (payloadDictionary[@"commits"] != nil) {
			_eventType = KRGithubEventPayloadTypePush;
			_commits = _parsedIssuesCommits(payloadDictionary[@"commits"]);
			NSDictionary *repositoryRefDict = @{@"ref" : payloadDictionary[@"ref"]};
			_repositoryRef = [[KRGithubRepositoryReference alloc]initWithDictionary:repositoryRefDict];
		} else if ([dictionary[@"type"]isEqualToString:@"PublicEvent"]){
			_eventType = KRGithubEventPayloadTypeOpenSourcedRepository;
		} else {
			_eventType = KRGithubEventPayloadTypeNone;
		}
	}
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
	NSString *creationDateString = dictionary[@"created_at"];
	if (creationDateString != nil) {
		_creationDate = [dateFormat dateFromString:creationDateString];
	}
	NSAssert(_creationDate != nil, @"Repository doesn't have a creation date!");
	return self;
}

- (BOOL)hasDetail {
	BOOL result = NO;
	switch (self.eventType) {
		case KRGithubEventPayloadTypeNone:
		case KRGithubEventPayloadTypeStarred:
		case KRGithubEventPayloadTypeFork:
		case KRGithubEventPayloadTypeFollow:
		case KRGithubEventPayloadTypeAddCollaborator:
		case KRGithubEventPayloadTypeCreatedRepository:
		case KRGithubEventPayloadTypeCreatedBranch:
			result = NO;
			break;
		case KRGithubEventPayloadTypeOpenedIssue:
		case KRGithubEventPayloadTypeReOpenedIssue:
		case KRGithubEventPayloadTypeCommentedOnIssue:
		case KRGithubEventPayloadTypeClosedIssue:
		case KRGithubEventPayloadTypePush:
		case KRGithubEventPayloadTypeOpenSourcedRepository:
			result = YES;
			break;
		default:
			break;
	}
	return result;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	
	_creationDate = [aDecoder decodeObjectForKey:@"CreationDate"];
	_actor = [aDecoder decodeObjectForKey:@"Actor"];
	_repository = [aDecoder decodeObjectForKey:@"Repository"];
	_eventType = [aDecoder decodeIntForKey:@"EventType"];
	_followee = [aDecoder decodeObjectForKey:@"Followee"];
	_addedMember = [aDecoder decodeObjectForKey:@"AddedMember"];
	_issue = [aDecoder decodeObjectForKey:@"Issue"];
	_repository = [aDecoder decodeObjectForKey:@"CreationDate"];
	_commits = [aDecoder decodeObjectForKey:@"Commits"];

	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:_creationDate forKey:@"CreationDate"];
	[aCoder encodeObject:_actor forKey:@"Actor"];
	[aCoder encodeObject:_repository forKey:@"Repository"];
	[aCoder encodeInt:_eventType forKey:@"EventType"];
	[aCoder encodeObject:_followee forKey:@"Followee"];
	[aCoder encodeObject:_addedMember forKey:@"AddedMember"];
	[aCoder encodeObject:_issue forKey:@"Issue"];
	[aCoder encodeObject:_repository forKey:@"RepositoryReference"];
	[aCoder encodeObject:_commits forKey:@"Commits"];

}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
	return [[object creationDate]isEqual:self.creationDate];
}

#pragma mark - Private

NSArray *_parsedIssuesCommits(NSArray *commits) {
	NSMutableArray *result = [[NSMutableArray alloc]init];
	for (NSDictionary *repositoryDictionary in commits) {
		KRGithubCommit *newCommit = [[KRGithubCommit alloc]initWithDictionary:repositoryDictionary];
		[result addObject:newCommit];
	}
	return result;
}

@end
