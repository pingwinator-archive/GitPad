//
//  KRAccount.m
//  KrakenKit
//
//  Created by Robert Widmann on 12/26/12.
//  Copyright (c) 2012 CodaFi. All rights reserved.
//

#import "KRAccount.h"

NSString *const KRGitHubDefaultAPIEndpoint = @"https://api.github.com";

@interface KRAccount ()

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, strong) NSURL *endPoint;

@end

@implementation KRAccount


#pragma mark - Object Lifecycle

+ (KRAccount*)accountWithUsername:(NSString*)username password:(NSString*)password {
	return [self accountWithUsername:username password:password endPoint:[NSURL URLWithString:KRGitHubDefaultAPIEndpoint]];
}

+ (KRAccount*)accountWithUsername:(NSString*)username password:(NSString*)password endPoint:(NSURL*)endPoint {
	return [[self alloc]initWithUsername:username password:password endPoint:endPoint];
}

- (id)initWithUsername:(NSString*)username password:(NSString*)password {
	self = [self initWithUsername:username password:password endPoint:[NSURL URLWithString:KRGitHubDefaultAPIEndpoint]];
	return self;
}

- (id)initWithUsername:(NSString*)username password:(NSString*)password endPoint:(NSURL*)endPoint {
	self = [super init];
	_username = username;
	_password = password;
	_endPoint = endPoint;
	return self;
}

#pragma mark - NSCoding

-(id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	
	self.username = [aDecoder decodeObjectForKey:@"Username"];
	self.password = [aDecoder decodeObjectForKey:@"Password"];
	
	return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:_username forKey:@"Username"];
	[encoder encodeObject:_password forKey:@"Password"];
}


@end