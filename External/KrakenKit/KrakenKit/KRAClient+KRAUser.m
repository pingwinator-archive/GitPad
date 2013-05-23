//
//  KRAClient+KRAUser.m
//  KrakenKit
//
//  Created by Robert Widmann on 4/30/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "KRAClient+KRAUser.h"
#import "KRAClient+KRAHandlerBlocks.h"
#import "KRAUser.h"

@interface KRAClient (KRAUserPrivate)

- (NSString *)endpointPathForUserID:(NSString *)userID endpoint:(NSString *)endpoint;

@end


@implementation KRAClient (KRAUser)

- (NSString *)endpointPathForUserID:(NSString *)userID {
	return [NSString stringWithFormat:@"users/%@", userID];
}

- (void)fetchUserWithID:(NSString *)userID completion:(KRAClientCompletionBlock)completionHandler {
	[self getPath:[self endpointPathForUserID:userID]
	   parameters:nil
		  success:[self successHandlerForResourceClass:[KRAUser class] clientHandler:completionHandler]
		  failure:NULL];
}


@end