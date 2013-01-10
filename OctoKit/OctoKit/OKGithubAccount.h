//
//  OKGithubAccount.h
//  OctoKit
//
//  Created by Robert Widmann on 12/6/12.
//  Copyright (c) 2012 CodaFi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OKGithubAccount : NSObject

+ (OKGithubAccount *)accountWithUsername:(NSString *)uName password:(NSString *)password;
- (id)initWithUsername:(NSString *)uName password:(NSString *)password;

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

@property (nonatomic) unsigned int sessionsCount;

@end
