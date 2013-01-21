//
//  KRRequest.h
//  KrakenKit
//
//  Created by Robert Widmann on 1/21/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KRGithubRequestDelegate;

@class KRSession;
@class UAGithubEngine;

@interface KRGithubRequest : NSOperation {
	BOOL _started;
}

@property (nonatomic, assign) UAGithubEngine *githubEngine;

// response
@property (nonatomic, assign) id<KRGithubRequestDelegate> delegate;
@property (nonatomic, readonly, copy) NSError *error;
@property (nonatomic, strong) KRSession *session;

// progress
@property (nonatomic, assign, readonly) size_t currentProgress;
@property (nonatomic, assign, readonly) size_t maximumProgress;

- (void)startRequest;
- (void)cancel;

// can be overridden
- (void)mainRequest;
- (void)mainFinished;

@end

@protocol KRGithubRequestDelegate <NSObject>

@required
- (void)githubRequestDidFinish:(KRGithubRequest*)op;

@end
