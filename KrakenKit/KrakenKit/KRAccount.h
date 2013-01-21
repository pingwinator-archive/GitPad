//
//  KRAccount.h
//  KrakenKit
//
//  Created by Robert Widmann on 1/21/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KRGithubLoginRequest;
@class UAGithubEngine;

@interface KRAccount : NSObject <NSCoding>

+ (KRAccount*)accountWithUsername:(NSString*)username password:(NSString*)password;
+ (KRAccount*)accountWithUsername:(NSString*)username password:(NSString*)password endPoint:(NSURL*)endPoint;

- (id)initWithUsername:(NSString*)username password:(NSString*)password;
- (id)initWithUsername:(NSString*)username password:(NSString*)password endPoint:(NSURL*)endPoint;

- (BOOL)login;

@property (nonatomic, copy, readonly) NSString *username;
@property (nonatomic, copy, readonly) NSString *password;
@property (nonatomic, strong, readonly) NSURL *endPoint;


@end
