//
//  KRGithubCommit.m
//  KrakenKit
//
//  Created by Alex Widmann on 2/17/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "KRGithubCommit.h"

@implementation KRGithubCommit

- (id)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	
	NSString *messageRes = dictionary[@"message"];
	if (messageRes != nil) {
		_message = messageRes;
	}
	
	NSString *shaRes = dictionary[@"sha"];
	if (shaRes != nil) {
		_sha = shaRes;
	}
	return self;
}

- (NSString*)descriptionString {
	NSMutableString *str = [NSMutableString stringWithFormat:@"%@ %@", [self.sha substringToIndex:8], self.message];
	if (str.length < 43) {
		return str;
	}
	return [[str substringToIndex:40]stringByAppendingString:@"..."];
}

@end
