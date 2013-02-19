//
//  KRGithubRepository.m
//  KrakenKit
//
//  Created by Robert Widmann on 2/10/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "KRGithubRepository.h"
#import "NSDate+JSONDate.h"

@interface KRGithubRepository ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign, getter = isPrivateRepository) BOOL privateRepository;
@property (nonatomic, strong) NSDate *lastUpdateDate;
@property (nonatomic, strong) NSDate *lastPushDate;
@property (nonatomic, copy) NSString *descriptionString;

@end

@implementation KRGithubRepository

- (id)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	
	NSString *nameRes = dictionary[@"full_name"];
	if (nameRes == nil) {
		nameRes = dictionary[@"name"];
		if (nameRes != nil) {
			_name = nameRes;
		} 
	} else {
		_name = nameRes;
	}
	NSNumber *privateEntry = dictionary[@"private"];
	if (privateEntry != nil) {
		_privateRepository = [privateEntry boolValue];
	}
	NSNumber *forkEntry = dictionary[@"fork"];
	if (forkEntry != nil) {
		_fork = [forkEntry boolValue];
	}
	NSString *description = dictionary[@"description"];
	if (description != nil) {
		_descriptionString = description;
	} else {
		description = @"";
	}
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
	_lastUpdateDate = [dateFormat dateFromString:dictionary[@"updated_at"]];
	_lastPushDate = [dateFormat dateFromString:dictionary[@"pushed_at"]];

	return self;
}

- (NSDate*)sortDate {
	NSComparisonResult dateCompare = [self.lastUpdateDate compare:self.lastPushDate];
	if (dateCompare == NSOrderedDescending) {
		return self.lastPushDate;
	}
	return self.lastUpdateDate;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	
	_name = [aDecoder decodeObjectForKey:@"name"];
	_privateRepository = [aDecoder decodeBoolForKey:@"private"];
	_lastUpdateDate = [aDecoder decodeObjectForKey:@"lastUpdateDate"];
	_lastPushDate = [aDecoder decodeObjectForKey:@"lastPushDate"];

	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.name forKey:@"name"];
	[aCoder encodeBool:self.isPrivateRepository forKey:@"private"];
	[aCoder encodeObject:self.lastUpdateDate forKey:@"lastUpdateDate"];
	[aCoder encodeObject:self.lastPushDate forKey:@"lastPushDate"];
}

@end

@interface KRGithubRepositoryReference ()

@property (nonatomic, copy) NSString *referenceName;
@property (nonatomic, copy) NSString *descriptionString;

@end

@implementation KRGithubRepositoryReference

- (id)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	
	NSString *nameRes = dictionary[@"ref"];
	if (nameRes != nil) {
		_referenceName = nameRes;
	}
	NSString *descriptionEntry = dictionary[@"description"];
	if (descriptionEntry != nil) {
		_descriptionString = descriptionEntry;
	}
	return self;
}

@end
