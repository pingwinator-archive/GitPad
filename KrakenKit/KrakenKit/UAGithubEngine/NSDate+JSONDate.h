//
//  NSDate+JSONDate.h
//  KrakenKit
//
//  Created by Alex Widmann on 2/17/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (JSONDate)

- (NSDate*) getDateFromJSON:(NSString *)dateString;

@end
