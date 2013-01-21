//
//  KRGithubNotificationsRequest.m
//  KrakenKit
//
//  Created by Robert Widmann on 1/21/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "KRGithubNotificationsRequest.h"
#import "UAGithubEngine.h"
#import "KRSession.h"

@interface KRGithubNotificationsRequest ()

@property (nonatomic, strong) NSArray *notifications;

@end

@implementation KRGithubNotificationsRequest

- (void)mainRequest {
	self.notifications = [self.session _fetchNotifications];
	if (self.notifications != nil) {
		[self _parseNotifications];
	}
}

-(void)_parseNotifications {
	
}

@end
