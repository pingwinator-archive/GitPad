//
//  KRAClient.h
//  KrakenKit
//
//  Created by Robert Widmann on 4/30/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "AFNetworking.h"

@class KRAUser, FXKeychain;
typedef void (^KRAClientCompletionBlock)(id responseObject, NSError *error);

@interface KRAClient : AFHTTPClient

+ (instancetype)sharedClient;

@property (nonatomic, strong, readonly) KRAUser *authenticatedUser;
@property (nonatomic, strong) NSString *accessToken;
@property (readonly) BOOL isAuthenticated;
@property (readonly) BOOL isLoggedIn;

- (void)authenticateUsername:(NSString *)username password:(NSString *)password completionHandler:(void (^)(BOOL success, NSError *error))completionHander;
- (void)logOut;

@end

@interface KRAClient (KRADefaults)

@property (nonatomic, strong, readonly) FXKeychain *userDefaults;
@property (nonatomic, strong, readonly) NSDictionary *authenticatedUserDefaults;

- (void)setObject:(id)object forDefaultedKey:(NSString *)key;
- (id)objectForKeyInDefaults:(NSString *)key;

@end