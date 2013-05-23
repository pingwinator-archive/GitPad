//
//  KRARepository.h
//  KrakenKit
//
//  Created by Robert Widmann on 4/30/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <Mantle/Mantle.h>

//#warning Unfinished KRARepository

@class KRAUser;

@interface KRARepository : MTLModel

@property (nonatomic, copy) NSString *repoID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) KRAUser *owner;
@property (nonatomic, copy) NSNumber *privateRepo;
@property (nonatomic, copy) NSString *repoDescription;
@property (nonatomic, copy) NSNumber *isFork;
@property (nonatomic, copy) NSURL *url;
@property (nonatomic, copy) NSURL *forkURL;
@property (nonatomic, copy) NSURL *keysURL;
@property (nonatomic, copy) NSURL *collaboratorsURL;
@property (nonatomic, copy) NSURL *teamsURL;
@property (nonatomic, copy) NSURL *hooksURL;
@property (nonatomic, copy) NSURL *issueEventsURL;
@property (nonatomic, copy) NSURL *eventsURL;
@property (nonatomic, copy) NSURL *assigneeURL;
@property (nonatomic, copy) NSURL *branchesURL;
@property (nonatomic, copy) NSURL *tagsURL;
@property (nonatomic, copy) NSURL *blobsURL;
@property (nonatomic, copy) NSURL *gitTagsURL;
@property (nonatomic, copy) NSURL *gitRefsURL;
@property (nonatomic, copy) NSURL *treesURL;
@property (nonatomic, copy) NSURL *statusesURL;
@property (nonatomic, copy) NSURL *stargazersURL;
@property (nonatomic, copy) NSURL *contributorsURL;
@property (nonatomic, copy) NSURL *subscribersURL;
@property (nonatomic, copy) NSURL *subscriptionURL;
@property (nonatomic, copy) NSURL *commitsURL;
@property (nonatomic, copy) NSURL *gitCommitsURL;
@property (nonatomic, copy) NSURL *commentsURL;
@property (nonatomic, copy) NSURL *issueCommentURL;
@property (nonatomic, copy) NSURL *contentsURL;
@property (nonatomic, copy) NSURL *mergesURL;
@property (nonatomic, copy) NSURL *archiveURL;
@property (nonatomic, copy) NSURL *downloadsURL;
@property (nonatomic, copy) NSURL *issuesURL;
@property (nonatomic, copy) NSURL *pullsURL;
@property (nonatomic, copy) NSURL *milestonesURL;
@property (nonatomic, copy) NSURL *labelsURL;
@property (nonatomic, copy) NSDate *createdAt;
@property (nonatomic, copy) NSDate *updatedAt;
@property (nonatomic, copy) NSDate *pushedAt;
@property (nonatomic, copy) NSURL *gitURL;
@property (nonatomic, copy) NSURL *sshURL;
@property (nonatomic, copy) NSURL *cloneURL;
@property (nonatomic, copy) NSURL *svnURL;
@property (nonatomic, copy) NSURL *homepageURL;
@property (nonatomic, copy) NSNumber *size;
@property (nonatomic, copy) NSNumber *watchersCount;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSNumber *hasIssues;
@property (nonatomic, copy) NSNumber *hasDownloads;
@property (nonatomic, copy) NSNumber *hasWiki;
@property (nonatomic, copy) NSNumber *forksCount;
@property (nonatomic, copy) NSURL *mirrorURL;
@property (nonatomic, copy) NSNumber *openIssuesCount;
@property (nonatomic, copy) NSString *masterBranch;
@property (nonatomic, copy) NSString *defaultBranch;

@end
