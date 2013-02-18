//
//  GPAccountManager.h
//  GitPad
//
//  Created by Robert Widmann on 2/10/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KRGithubAccount;

@interface GPAccountManager : NSObject

+ (GPAccountManager *) sharedManager;

- (void) addAccount:(KRGithubAccount *)account;
- (void) removeAccount:(KRGithubAccount *)account;

- (KRGithubAccount*)accountForUsername:(NSString*)email;

- (void) saveChanges;

@property (nonatomic, strong, readonly) NSMutableArray * /*KRGithubAccount*/ accounts;
@property (nonatomic, strong) NSMutableArray * /*KRGithubAccount*/ accountsShadow;


@end