//
//  KRAccount.m
//  KrakenKit
//
//  Created by Robert Widmann on 1/21/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "KRGithubAccount.h"
#import "UAGithubEngine.h"
#import "KRSession.h"
#import "KRGithubRepository.h"
#import "KRGithubEvent.h"
#import "KRGithubNotification.h"

NSString *const KRGitHubDefaultAPIEndpoint = @"https://api.github.com";
NSString *const KRGithubAccountUsernameKey = @"KRUsernameKey";
NSString *const KRGithubAccountPasswordKey = @"KRPasswordKey";
NSString *const KRGithubAccountEndpointKey = @"KREndpointKey";

RACScheduler *syncScheduler() {
	static RACScheduler *syncScheduler = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		syncScheduler = [RACScheduler scheduler];
	});
	return syncScheduler;
}

// Returns the current scheduler
RACScheduler *currentScheduler() {
	NSCAssert(RACScheduler.currentScheduler != nil, @"KrakenKit called from a thread without a RACScheduler.");
	return RACScheduler.currentScheduler;
}

@interface KRGithubAccount ()

@property (nonatomic, strong) KRSession *session;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, strong) NSURL *endPoint;
@property (nonatomic, assign) BOOL finished;

@property (nonatomic, copy) NSArray *repositories;
@property (nonatomic, copy) NSArray *events;
@property (nonatomic, strong) NSURL *avatarURL;
@property (nonatomic, strong) NSURL *blogURL;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, assign) NSUInteger publicRepositories;

@end

@implementation KRGithubAccount {
	NSURL* _repositoryURL;
	NSURL* _eventsURL;
	NSURL* _recievedEventsURL;
	NSInteger _ownedPrivateRepositories;
	long long _userID;
	NSInteger _privateGists;
	NSURL* _subscriptionsURL;
	long long _diskUsage;
	NSURL* _userURL;
	NSInteger _publicGists;
	NSURL* _organizationsURL;
	NSURL* _followingURL;
	KRGithubAccountType _type;
	NSDate* _accountCreationDate;
	NSURL* _followersURL;
	NSString* _location;
	NSInteger _following;
	NSURL* _gistsURL;
	NSInteger _collaborators;
	KRGithubAccountPlan* _plan;
	NSString* _bio;
	NSInteger _totalPrivateRepositories;
	NSString* _gravatarID;
	NSInteger _followers;
	NSURL* _htmlURL;
	NSDate* _updatedAt;
	BOOL _hireable;
	NSURL* _starredURL;
}


#pragma mark - Object Lifecycle

+ (KRGithubAccount*)accountWithDictionary:(NSDictionary*)dictionary {
	return [[self alloc]initWithDictionary:dictionary];
}

+ (KRGithubAccount*)accountWithUsername:(NSString*)username password:(NSString*)password {
	return [self accountWithUsername:username password:password endPoint:[NSURL URLWithString:KRGitHubDefaultAPIEndpoint]];
}

+ (KRGithubAccount*)accountWithUsername:(NSString*)username password:(NSString*)password endPoint:(NSURL*)endPoint {
	return [[self alloc]initWithUsername:username password:password endPoint:endPoint];
}

- (id)initWithDictionary:(NSDictionary*)dictionary {
	self = [super init];
//	_requestFullUserFromURL(dictionary[@"url"], dictionary[@"login"], ^(NSArray *__strong resp) {
//		NSDictionary *userResponse = resp.lastObject;
		NSDictionary *userResponse = dictionary;
		self.username = userResponse[@"login"];
		self.avatarURL = [NSURL URLWithString:userResponse[@"avatar_url"]];
		self.name = userResponse[@"name"];
		self.publicRepositories = [userResponse[@"public_repos"] unsignedIntegerValue];
		self.location = userResponse[@"location"];
		self.email = userResponse[@"email"];
		if(![userResponse[@"blog"] isKindOfClass:[NSNull class]])
			self.blogURL = [NSURL URLWithString:userResponse[@"blog"]];
		else {
			self.blogURL = [NSURL URLWithString:@""];
		}
		if(![userResponse[@"company"] isKindOfClass:[NSNull class]])
			self.companyName = [NSURL URLWithString:userResponse[@"company"]];
		else {
			self.companyName = @"";
		}
//	});
	return self;
}

- (id)initWithUsername:(NSString*)username password:(NSString*)password {
	self = [self initWithUsername:username password:password endPoint:[NSURL URLWithString:KRGitHubDefaultAPIEndpoint]];
	return self;
}

- (id)initWithUsername:(NSString*)username password:(NSString*)password endPoint:(NSURL*)endPoint {
	self = [super init];
	
	_session = [[KRSession alloc]initWithUsername:username password:password];
	_username = username;
	_password = password;
	_endPoint = endPoint;
	
	return self;
}

- (NSDictionary*)dictionaryRepresentation {
	NSMutableDictionary *dict = @{}.mutableCopy;
	[dict setObject:self.username forKey:@"login"];

	return dict;
}

#pragma Account Management

void _requestFullUserFromURL(NSString *urlString, NSString *username, void(^successBlock)(NSArray *user)) {
	KRSession *disposableSession = [[KRSession alloc]initWithUsername:username password:nil];
	[disposableSession _user:username withSuccess:successBlock failure:^(NSError *error) {
		//Do something
	}];
}

- (RACSignal *)login {
	return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		return [syncScheduler() schedule:^{
			[self.session _fetchRepositoriesWithSuccess:^(NSArray *user){
				[subscriber sendCompleted];
			} failure:^(NSError *error){
				[subscriber sendError:error];
			}];
		}];
	}]deliverOn:currentScheduler()];
}

- (RACSignal *)syncRepositories {
	return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		return [syncScheduler() schedule:^{
			[self.session _fetchRepositoriesWithSuccess:^(NSArray *repositories){
				[subscriber sendNext:_parsedRepositories(repositories)];
				[subscriber sendCompleted];
			} failure:^(NSError *error){
				[subscriber sendError:error];
			}];
		}];
	}]deliverOn:currentScheduler()];
}

static NSArray *_parsedRepositories(NSArray *dirtyRepos) {
	NSMutableArray *result = [[NSMutableArray alloc]init];
	for (NSDictionary *repositoryDictionary in dirtyRepos) {
		KRGithubRepository *newRepo = [[KRGithubRepository alloc]initWithDictionary:repositoryDictionary];
		[result addObject:newRepo];
	}
	return [result sortedArrayUsingComparator:^NSComparisonResult(KRGithubRepository *obj1, KRGithubRepository *obj2) {
		return [obj2.sortDate compare:obj1.sortDate];
	}];
}


- (RACSignal *)syncNewsFeed {
	return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		return [syncScheduler() schedule:^{
			[self.session _fetchEventsWithSuccess:^(NSArray *events){
				self.events = _parsedEvents(events);
				[subscriber sendNext:self.events];
				[subscriber sendCompleted];
			} failure:^(NSError *error){
				[subscriber sendError:error];
			}];
		}];
	}]deliverOn:currentScheduler()];
}

static NSArray *_parsedEvents(NSArray *dirtyEvents) {
	NSMutableArray *result = [[NSMutableArray alloc]init];
	NSMutableSet *uniquingSet = [[NSMutableSet alloc]init];
	for (NSDictionary *repositoryDictionary in dirtyEvents) {
		KRGithubEvent *newRepo = [[KRGithubEvent alloc]initWithDictionary:repositoryDictionary];
		[uniquingSet addObject:newRepo];
		[result addObject:newRepo];
	}
	return [result sortedArrayUsingComparator:^NSComparisonResult(KRGithubEvent *obj1, KRGithubEvent *obj2) {
		return [obj2.creationDate compare:obj1.creationDate];
	}];
}

- (RACSignal *)syncNotifications {
	return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		return [syncScheduler() schedule:^{
			[self.session _fetchNotificationsWithSuccess:^(NSArray *notifications){
				self.repositories = _parsedNotifications(notifications);
				[subscriber sendNext:self.repositories];
				[subscriber sendCompleted];
			} failure:^(NSError *error){
				[subscriber sendError:error];
			}];
		}];
	}]deliverOn:currentScheduler()];
}

static NSArray *_parsedNotifications(NSArray *dirtyNotifications) {
	NSMutableArray *result = [[NSMutableArray alloc]init];
	for (NSDictionary *repositoryDictionary in dirtyNotifications) {
		KRGithubNotification *newNotification = [[KRGithubNotification alloc]initWithDictionary:repositoryDictionary];
		[result addObject:newNotification];
	}
	return result;
}


#pragma mark - NSCoding

-(id)initWithCoder:(NSCoder *)aDecoder {
	self = [self initWithUsername:[aDecoder decodeObjectForKey:@"Username"] password:[aDecoder decodeObjectForKey:@"Password"]];
	
	_repositories = [aDecoder decodeObjectForKey:@"Repositories"];
	_events = [aDecoder decodeObjectForKey:@"Events"];
	
	return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:_username forKey:@"Username"];
	[encoder encodeObject:_password forKey:@"Password"];
	[encoder encodeObject:_repositories forKey:@"Repositories"];
	[encoder encodeObject:_events forKey:@"Events"];
}


@end
