//
//  KRSession.h
//  KrakenKit
//
//  Created by Robert Widmann on 1/21/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UAGithubEngine, RACSignal;

@interface KRSession : NSObject {
	NSOperationQueue * _queue;
}

- (id)initWithUsername:(NSString*)username password:(NSString*)password;

@property (nonatomic, strong, readonly) UAGithubEngine *githubEngine;

@end

@interface KRSession (Private)

- (void)_login;
- (void)_fetchRepositoriesWithSuccess:(void(^)(NSArray *notifications))successBlock failure:(void(^)(NSError *error))failureBlock;
- (void)_fetchEventsWithSuccess:(void(^)(NSArray *events))successBlock failure:(void(^)(NSError *error))failureBlock;
- (void)_fetchNotificationsWithSuccess:(void(^)(NSArray *events))successBlock failure:(void(^)(NSError *error))failureBlock;

@end