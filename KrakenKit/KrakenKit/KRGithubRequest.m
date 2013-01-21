//
//  LEPIMAPRequest.m
//  etPanKit
//
//  Created by DINH Viêt Hoà on 03/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KRGithubRequest.h"
#import "KRSession.h"

@interface KRGithubRequest ()

@property (nonatomic, copy) NSError * error;

- (void) _finished;

@end

@implementation KRGithubRequest

@synthesize delegate = _delegate;
@synthesize error = _error;
@synthesize session = _session;

- (id) init
{
	self = [super init];
	
	return self;
}

- (void) startRequest
{
	_started = YES;
	[_session enqueueRequest:self];
}

- (void) cancel
{
	[super cancel];
}

- (void) main
{
	if ([self isCancelled]) {
		if (_started) {
			_started = NO;
		}
		return;
	}
	
	[self mainRequest];
   	[self performSelectorOnMainThread:@selector(_finished) withObject:nil waitUntilDone:NO];
}

- (void) mainRequest
{
}

- (void) mainFinished
{
}

- (void) _finished
{
	if ([self isCancelled]) {
		if (_started) {
			_started = NO;
		}
		return;
	}
	
	[self mainFinished];
	[self.delegate githubRequestDidFinish:self];
    
	if (_started) {
		_started = NO;
	}
}

- (size_t) currentProgress
{
    return 0;
}

- (size_t) maximumProgress
{
    return 0;
}

@end
