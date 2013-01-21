//
//  KRSession.h
//  KrakenKit
//
//  Created by Robert Widmann on 1/21/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KRGithubRequest;
@class UAGithubEngine;

@interface KRSession : NSObject {
	NSOperationQueue * _queue;
}

- (id)initWithUsername:(NSString*)username password:(NSString*)password;
- (void)enqueueRequest:(KRGithubRequest*)request;

@property (nonatomic, strong, readonly) UAGithubEngine *githubEngine;

@end

@interface KRSession (Private)

- (BOOL)_login;

@end