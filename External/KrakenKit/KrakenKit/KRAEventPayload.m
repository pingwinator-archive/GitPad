//
//  KRAEventPayload.m
//  KrakenKit
//
//  Created by Robert Widmann on 5/12/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "KRAEventPayload.h"
#import "KRACommit.h"
#import "KRAIssue.h"
#import "KRAComment.h"

@implementation KRAEventPayload

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"action" : @"action",
		@"number" : @"number",
		@"pushID" : @"push_id",
		@"size" : @"size",
		@"distinctSize" : @"distinct_size",
		@"ref" : @"ref",
		@"head" : @"head",
		@"before" : @"before",
		@"commits" : @"commits",
		@"isPublic" : @"public",
		@"createdAt" : @"created_at",
		@"issue" : @"issue",
		@"comment" : @"comment"
	};
}

+ (NSValueTransformer *)actionJSONTransformer {
	NSDictionary *actionTypes = @{
		@"opened" : @(KRAGithubActionTypeOpened),
		@"closed" : @(KRAGithubActionTypeClosed),
		@"created" : @(KRAGithubActionTypeCreated)
	};
	
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return actionTypes[str];
    } reverseBlock:^(NSNumber *state) {
        return [actionTypes allKeysForObject:state].lastObject;
    }];
}

+ (NSValueTransformer *)commitsJSONTransformer {
    return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:KRACommit.class];
}

+ (NSValueTransformer *)issueJSONTransformer {
    return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:KRAIssue.class];
}

+ (NSValueTransformer *)commentJSONTransformer {
    return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:KRAComment.class];
}

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
		dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
	}
    return dateFormatter;
}

+ (NSValueTransformer *)createdAtJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

@end

