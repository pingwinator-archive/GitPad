//
//  KRAccount.m
//  KrakenKit
//
//  Created by Robert Widmann on 1/21/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "KRGithubAccount.h"
#import "UAGithubEngine.h"
#import "KRGithubNotificationsRequest.h"
#import "KRSession.h"

NSString *const KRGitHubDefaultAPIEndpoint = @"https://api.github.com";

@interface KRGithubAccount ()

@property (nonatomic, strong) KRSession *session;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, strong) NSURL *endPoint;

@end

@implementation KRGithubAccount {
	NSURL* _repositoryURL;
	NSString* _email;
	NSURL* _eventsURL;
	NSURL* _recievedEventsURL;
	NSInteger _ownedPrivateRepositories;
	long long _userID;
	NSURL* _avatarURL;
	NSInteger _privateGists;
	NSURL* _subscriptionsURL;
	NSURL* _blogURL;
	long long _diskUsage;
	NSURL* _userURL;
	NSInteger _publicGists;
	NSURL* _organizationsURL;
	NSURL* _followingURL;
	KRGithubAccountType _type;
	NSString* _companyName;
	NSDate* _accountCreationDate;
	NSURL* _followersURL;
	NSString* _location;
	NSString* _name;
	NSInteger _publicRepositories;
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

+ (KRGithubAccount*)accountWithUsername:(NSString*)username password:(NSString*)password {
	return [self accountWithUsername:username password:password endPoint:[NSURL URLWithString:KRGitHubDefaultAPIEndpoint]];
}

+ (KRGithubAccount*)accountWithUsername:(NSString*)username password:(NSString*)password endPoint:(NSURL*)endPoint {
	return [[self alloc]initWithUsername:username password:password endPoint:endPoint];
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

#pragma Account Management

- (BOOL)login {
	NSArray *userResponse = [self.session _login];
	
	return (userResponse != nil);
}

- (KRGithubNotificationsRequest*)notificationsRequest {
	KRGithubNotificationsRequest *request = [[KRGithubNotificationsRequest alloc]init];
	
	return request;
}

#pragma mark - NSCoding

-(id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	
	self.username = [aDecoder decodeObjectForKey:@"Username"];
	self.password = [aDecoder decodeObjectForKey:@"Password"];
	
	return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:_username forKey:@"Username"];
	[encoder encodeObject:_password forKey:@"Password"];
}


@end
