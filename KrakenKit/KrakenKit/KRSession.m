//
//  KRSession.m
//  KrakenKit
//
//  Created by Robert Widmann on 1/21/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "KRSession.h"
#import "KRGithubRequest.h"
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

- (void)enqueueRequest:(KRGithubRequest*)request {
	request.githubEngine = self.githubEngine;
	[_queue addOperation:request];
}

- (NSArray*)_login {
	__block NSArray *success = nil;
	
	[self.githubEngine userWithSuccess:^(NSArray *user) {
		success = user;
	} failure:^(NSError *error) { }];
	return success;
}

- (void)_fetchRepositoriesWithSuccess:(void(^)(NSArray *notifications))successBlock failure:(void(^)(NSError *error))failureBlock {
	[self.githubEngine repositoriesWithSuccess:successBlock failure:failureBlock];
}

@end
