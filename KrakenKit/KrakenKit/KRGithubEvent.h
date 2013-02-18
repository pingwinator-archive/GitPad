//
//  KRGithubEvent.h
//  KrakenKit
//
//  Created by Alex Widmann on 2/17/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KRGithubAccount, KRGithubRepository, KRGithubIssue, KRGithubRepositoryReference;

typedef NS_ENUM(int, KRGithubEventPayloadType) {
	KRGithubEventPayloadTypeNone,
	KRGithubEventPayloadTypeStarred,
	KRGithubEventPayloadTypeFork,
	KRGithubEventPayloadTypeFollow,
	KRGithubEventPayloadTypeAddCollaborator,
	KRGithubEventPayloadTypeCreatedRepository,
	KRGithubEventPayloadTypeCreatedBranch,
	KRGithubEventPayloadTypeOpenedIssue,
	KRGithubEventPayloadTypeReOpenedIssue,
	KRGithubEventPayloadTypeCommentedOnIssue,
	KRGithubEventPayloadTypeClosedIssue,
	KRGithubEventPayloadTypePush,
	KRGithubEventPayloadTypeOpenSourcedRepository
};

@interface KRGithubEvent : NSObject <NSCoding>

@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) KRGithubAccount *actor;
@property (nonatomic, strong) KRGithubRepository *repository;

@property (nonatomic, assign) KRGithubEventPayloadType eventType;

@property (nonatomic, strong) KRGithubAccount *followee;

@property (nonatomic, strong) KRGithubAccount *addedMember;

@property (nonatomic, strong) KRGithubIssue *issue;

@property (nonatomic, strong) KRGithubRepositoryReference *repositoryRef;

@property (nonatomic, strong) NSArray *commits;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (BOOL)hasDetail;

@end
