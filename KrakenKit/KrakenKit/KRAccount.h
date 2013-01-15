//
//  KRAccount.h
//  KrakenKit
//
//  Created by Robert Widmann on 12/26/12.
//  Copyright (c) 2012 CodaFi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KrakenKit.h"

@interface KRAccount : NSObject <NSCoding>

+ (KRAccount*)accountWithUsername:(NSString*)username password:(NSString*)password;
+ (KRAccount*)accountWithUsername:(NSString*)username password:(NSString*)password endPoint:(NSURL*)endPoint;

- (id)initWithUsername:(NSString*)username password:(NSString*)password;
- (id)initWithUsername:(NSString*)username password:(NSString*)password endPoint:(NSURL*)endPoint;

@property (nonatomic, copy, readonly) NSString *username;
@property (nonatomic, copy, readonly) NSString *password;
@property (nonatomic, strong, readonly) NSURL *endPoint;


@end
