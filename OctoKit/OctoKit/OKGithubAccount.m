//
//  OKGithubAccount.m
//  OctoKit
//
//  Created by Robert Widmann on 12/6/12.
//  Copyright (c) 2012 CodaFi. All rights reserved.
//

#import "OKGithubAccount.h"

@interface OKGithubAccount ()

@end

@implementation OKGithubAccount

+ (OKGithubAccount *)accountWithUsername:(NSString *)uName password:(NSString *)password {
	OKGithubAccount *result = [[[self class]alloc] initWithUsername:uName password:password];
	return result;
}

- (id)initWithUsername:(NSString *)uName password:(NSString *)password {
	if (self = [super init])
	{
		_username = uName;
		_password = password;
		_sessionsCount = 1;
	}
	return self;
}

- (LEPIMAPCheckRequest *) checkRequest;


@end
