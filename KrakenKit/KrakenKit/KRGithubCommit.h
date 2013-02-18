//
//  KRGithubCommit.h
//  KrakenKit
//
//  Created by Alex Widmann on 2/17/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KRGithubCommit : NSObject

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy) NSString *sha;
@property (nonatomic, copy) NSString *message;


@end
