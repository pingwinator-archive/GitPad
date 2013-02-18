//
//  KRGithubIssue.m
//  KrakenKit
//
//  Created by Alex Widmann on 2/17/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "KRGithubIssue.h"

@implementation KRGithubIssue

- (id)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	
	NSNumber *issueNumber = dictionary[@"number"];
	if (issueNumber != nil) {
		_issueNumber = [issueNumber unsignedIntegerValue];
	}
	NSString *state = dictionary[@"state"];
	if ([state isEqualToString:@"open"]) {
		_state = KRGithubIssueStateOpen;
	} else if ([state isEqualToString:@"closed"]) {
		_state = KRGithubIssueStateClosed;
	}
	NSString *title = dictionary[@"title"];
	if (title != nil) {
		_title = title;
	} else {
		_title = @"";
	}
	
	return self;
}

@end
