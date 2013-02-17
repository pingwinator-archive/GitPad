//
//  KRGithubRepository.h
//  KrakenKit
//
//  Created by Robert Widmann on 2/10/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KRGithubRepository : NSObject

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, assign, readonly, getter = isPrivateRepository) BOOL privateRepository;

@end