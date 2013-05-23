//
//  KRAClient+KRAUser.h
//  KrakenKit
//
//  Created by Robert Widmann on 4/30/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "KRAClient.h"

@interface KRAClient (KRAUser)

- (void)fetchUserWithID:(NSString *)userID completion:(KRAClientCompletionBlock)completionHandler;
@end
