//
//  KRGithubIssue.h
//  KrakenKit
//
//  Created by Alex Widmann on 2/17/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, KRGithubIssueState) {
	KRGithubIssueStateOpen,
	KRGithubIssueStateClosed
};

@interface KRGithubIssue : NSObject

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, assign) KRGithubIssueState state;
@property (nonatomic, assign) NSUInteger issueNumber;
@property (nonatomic, copy) NSString *title;

@end
