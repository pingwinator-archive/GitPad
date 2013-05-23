//
//  GPAccount.h
//  GitPad
//
//  Created by Robert Widmann on 4/30/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPAccount : NSObject

- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password;

@property (copy) NSString *password;
@property (copy) NSString *username;

@property (strong, readonly) NSDictionary *dictionaryRepresentation;

@end
