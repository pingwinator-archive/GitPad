//
//  KRGithubRepository.m
//  KrakenKit
//
//  Created by Robert Widmann on 2/10/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "KRGithubRepository.h"

@interface KRGithubRepository ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign, getter = isPrivateRepository) BOOL privateRepository;

@end

@implementation KRGithubRepository

- (id)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	
	_name = [dictionary objectForKey:@"name"];
	_privateRepository = [[dictionary objectForKey:@"private"]boolValue];
	
	return self;
}

@end
