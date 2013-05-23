//
//  GPAccount.m
//  GitPad
//
//  Created by Robert Widmann on 4/30/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "GPAccount.h"

@implementation GPAccount

- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password {
	self = [super init];
	
	_username = username;
	_password = password;
	
	return self;
}


- (NSDictionary *)dictionaryRepresentation {
	return @{ @"login" : self.username };
}

@end
