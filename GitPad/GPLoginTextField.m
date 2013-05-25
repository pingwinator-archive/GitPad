//
//  GPLoginTextField.m
//  GitPad
//
//  Created by Robert Widmann on 5/24/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "GPLoginTextField.h"
#import <QuartzCore/QuartzCore.h>

@implementation GPLoginTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.layer.cornerRadius = 5.0f;
		self.layer.masksToBounds = YES;
		self.layer.borderWidth = 2.0f;
		self.layer.borderColor = [[UIColor colorWithWhite:0.802 alpha:1.000]CGColor];
		self.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    }
    return self;
}

- (BOOL)becomeFirstResponder {
    self.layer.borderColor = [[UIColor colorWithRed:0.718 green:0.853 blue:0.960 alpha:1.000]CGColor];
	return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
	self.layer.borderColor = [[UIColor colorWithWhite:0.802 alpha:1.000]CGColor];
	return [super resignFirstResponder];
}

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
	return CGRectInset( bounds , 10 , 10 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
	return CGRectInset( bounds , 10 , 10 );
}
@end
