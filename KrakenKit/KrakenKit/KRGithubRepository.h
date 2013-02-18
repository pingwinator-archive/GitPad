//
//  KRGithubRepository.h
//  KrakenKit
//
//  Created by Robert Widmann on 2/10/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KRGithubRepository : NSObject <NSCoding>

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, strong, readonly) NSDate *lastPushDate;
@property (nonatomic, strong, readonly) NSDate *lastUpdateDate;
@property (nonatomic, strong, readonly) NSDate *sortDate;

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, assign, readonly, getter = isPrivateRepository) BOOL privateRepository;

@property (nonatomic, copy, readonly) NSString *descriptionString;

@end

@interface KRGithubRepositoryReference : NSObject

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy, readonly) NSString *referenceName;
@property (nonatomic, copy, readonly) NSString *descriptionString;

@end

