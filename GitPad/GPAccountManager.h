//
//  GPAccountManager.h
//  GitPad
//
//  Created by Robert Widmann on 2/10/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GPAccount;

@interface GPAccountManager : NSObject

+ (GPAccountManager *) sharedManager;

- (void) addAccount:(GPAccount *)account;
- (void) removeAccount:(GPAccount *)account;

- (GPAccount*)accountForUsername:(NSString*)email;

- (void) saveChanges;

@property (nonatomic, strong, readonly) NSMutableArray * /*GPAccount*/ accounts;
@property (nonatomic, strong) NSMutableArray * /*GPAccount*/ accountsShadow;


@end