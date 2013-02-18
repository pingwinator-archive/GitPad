//
//  KRSession.m
//  KrakenKit
//
//  Created by Robert Widmann on 1/21/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "KRSession.h"
#import "UAGithubEngine.h"

@interface KRSession ()

@property (nonatomic, strong) UAGithubEngine *githubEngine;

@end

@implementation KRSession

- (id)initWithUsername:(NSString *)username password:(NSString *)password {
	self = [super init];
	
	_githubEngine = [[UAGithubEngine alloc]initWithUsername:username password:password withReachability:NO];

	_queue = [[NSOperationQueue alloc] init];
	[_queue setMaxConcurrentOperationCount:1];
	
	return self;
}

- (void)_loginWithSuccess:(void(^)(NSArray *user))successBlock failure:(void(^)(NSError *error))failureBlock {	
	[self.githubEngine userWithSuccess:successBlock failure:failureBlock];
}

- (void)_fetchRepositoriesWithSuccess:(void(^)(NSArray *notifications))successBlock failure:(void(^)(NSError *error))failureBlock {
	[self.githubEngine repositoriesWithSuccess:successBlock failure:failureBlock];
}

- (void)_fetchEventsWithSuccess:(void(^)(NSArray *events))successBlock failure:(void(^)(NSError *error))failureBlock {
	[self.githubEngine eventsReceivedByUser:self.githubEngine.username success:successBlock failure:failureBlock];
}

- (void)_fetchNotificationsWithSuccess:(void(^)(NSArray *events))successBlock failure:(void(^)(NSError *error))failureBlock {
	[self.githubEngine notificationsWithSuccess:successBlock failure:failureBlock];
}

@end
