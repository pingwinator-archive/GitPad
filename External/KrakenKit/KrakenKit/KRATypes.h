//
//  KRATypes.h
//  KrakenKit
//
//  Created by Robert Widmann on 4/30/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#ifndef KrakenKit_KRATypes_h
#define KrakenKit_KRATypes_h

#include "metamacros.h"

typedef NS_ENUM(NSUInteger, KRAErrorType) {
	KRAErrorTypeUnknown = 0,
	KRAErrorTypeInvalidToken,
	KRAErrorTypeNotAuthorized,
	KRAErrorTypeTokenExpired,
	KRAErrorTypeCodeUsed,
	KRAErrorTypeRedirectURIRequired
};


typedef NS_ENUM(NSUInteger, KRAHTTPStatus) {
	KRAHTTPStatusOK = 200,
	KRAHTTPStatusBadRequest = 400,
	KRAHTTPStatusForbidden = 403,
	KRAHTTPStatusNotAllowed = 405,
	KRAHTTPStatusCLAccountOnly = 419,
	KRAHTTPStatusInternalServerError = 500,
};


static NSString *const kKRAErrorDomain = @"KRAErrorDomain";
static NSString *const kKRAErrorTypeKey = @"KRAErrorType";
static NSString *const kKRAErrorIDKey = @"KRAErrorID";

//#error A client ID and a client secret must be specified
#define KRAGithubClientID @""
#define KRAGithubClientSecret @""

#endif
