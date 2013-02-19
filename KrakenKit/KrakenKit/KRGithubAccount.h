//
//  KRAccount.h
//  KrakenKit
//
//  Created by Robert Widmann on 1/21/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

FOUNDATION_EXPORT NSString *const KRGithubAccountUsernameKey;
FOUNDATION_EXPORT NSString *const KRGithubAccountPasswordKey;
FOUNDATION_EXPORT NSString *const KRGithubAccountEndpointKey;

typedef NS_ENUM(int, KRGithubAccountType) {
	KRGithubAccountTypeUser = 0,
	KRGithubAccountTypeOrganization
};

@class KRGithubAccountPlan;
@class UAGithubEngine;

@interface KRGithubAccount : NSObject <NSCoding>

+ (KRGithubAccount*)accountWithDictionary:(NSDictionary*)dictionary;
+ (KRGithubAccount*)accountWithUsername:(NSString*)username password:(NSString*)password;
+ (KRGithubAccount*)accountWithUsername:(NSString*)username password:(NSString*)password endPoint:(NSURL*)endPoint;

- (id)initWithDictionary:(NSDictionary*)dictionary;
- (id)initWithUsername:(NSString*)username password:(NSString*)password;
- (id)initWithUsername:(NSString*)username password:(NSString*)password endPoint:(NSURL*)endPoint;

- (RACSignal *)login;
- (RACSignal *)syncRepositories;
- (RACSignal *)syncNewsFeed;
- (RACSignal *)syncNotifications;

@property (nonatomic, copy, readonly) NSArray *repositories;
@property (nonatomic, copy, readonly) NSArray *events;
@property (nonatomic, copy, readonly) NSArray *issueEvents;

@property (nonatomic, copy, readonly) NSString *username;
@property (nonatomic, copy, readonly) NSString *password;
@property (nonatomic, strong, readonly) NSURL *endPoint;
@property (nonatomic, copy, readonly) NSString *email;

- (NSURL*)repositoryURL;
- (NSURL*)eventsURL;
- (NSURL*)recievedEventsURL;
- (NSInteger)ownedPrivateRepositories;
- (long long)userID;
@property (nonatomic, strong, readonly) NSURL *avatarURL;
- (NSInteger)privateGists;
- (NSURL*)subscriptionsURL;
@property (nonatomic, strong, readonly) NSURL *blogURL;
- (long long)diskUsage;
- (NSURL*)userURL;
- (NSInteger)publicGists;
- (NSURL*)organizationsURL;
- (NSURL*)followingURL;
- (KRGithubAccountType)type;
@property (nonatomic, copy, readonly) NSString *companyName;
- (NSDate*)accountCreationDate;
- (NSURL*)followersURL;
@property (nonatomic, copy, readonly) NSString *location;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, assign, readonly) NSUInteger publicRepositories;

- (NSInteger)following;
- (NSURL*)gistsURL;
- (NSInteger)collaborators;
- (KRGithubAccountPlan*)plan;
- (NSString*)bio;
- (NSInteger)totalPrivateRepositories;
- (NSString*)gravatarID;
- (NSInteger)followers;
- (NSURL*)htmlURL;
- (NSDate*)updatedAt;
- (BOOL)hireable;
- (NSURL*)starredURL;

- (NSDictionary*)dictionaryRepresentation;

@end

