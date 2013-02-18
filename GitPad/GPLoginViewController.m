//
//  GPLoginViewController.m
//  GitPad
//
//  Created by Robert Widmann on 11/29/12.
//  Copyright (c) 2012 CodaFi. All rights reserved.
//

#import "GPLoginViewController.h"
#import "GPNavigationController.h"
#import "GPNavigationBar.h"
#import "GPAppDelegate.h"
#import "GPConstants.h"
#import "KrakenKit.h"
#import "UIImage+PDF.h"
#import "WBNoticeView.h"
#import "WBErrorNoticeView.h"
#import "WBSuccessNoticeView.h"
#import "WBStickyNoticeView.h"
#import "NSOperationQueue+WBNoticeExtensions.h"

@interface GPLoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) GPNavigationBar *navigationBar;

@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation GPLoginViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
	// Do any additional setup after loading the view.
    [super viewDidLoad];
	self.navigationBar = [[GPNavigationBar alloc]initWithFrame:CGRectMake(0, 0, 540, 44)];
	self.navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	self.navigationBar.titleImage = [UIImage imageWithPDFNamed:@"<Blacktocats>.pdf" atSize:CGSizeMake(32, 32)];
	self.navigationBar.drawRect = ^(GPNavigationBar *bar, CGRect dirtyRect) {
		CGRect drawingRect = [bar bounds];
		
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		UIColor *startColor = [UIColor colorWithRed:0.425 green:0.512 blue:0.581 alpha:1.000];
		UIColor *endColor = [UIColor colorWithRed:0.351 green:0.438 blue:0.504 alpha:1.000];
				
		CGGradientRef gradient = createGradientWithColors(startColor, endColor);
		CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMidX(drawingRect), CGRectGetMinY(drawingRect)),
									CGPointMake(CGRectGetMidX(drawingRect), CGRectGetMaxY(drawingRect)), 0);
		CGGradientRelease(gradient);
		
		[[UIColor colorWithRed:0.273 green:0.333 blue:0.375 alpha:1.000] set];
		CGContextSetLineWidth(context,1.0f);
		CGContextMoveToPoint(context,0.0f, CGRectGetMaxY(drawingRect));
		CGContextAddLineToPoint(context,CGRectGetMaxX(drawingRect), CGRectGetMaxY(drawingRect));
		CGContextStrokePath(context);
	};
	
	[self.view addSubview:self.navigationBar];
	
	self.usernameField = [[UITextField alloc]initWithFrame:CGRectMake(145, 163, 250, 44)];
	self.usernameField.delegate = self;
	[self.usernameField setBackgroundColor:[UIColor whiteColor]];
	self.usernameField.borderStyle = UITextBorderStyleLine;
	self.usernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	[self.usernameField setPlaceholder:@"Username"];
	[self.usernameField setReturnKeyType:UIReturnKeyNext];
	[self.view addSubview:self.usernameField];
	
	self.passwordField = [[UITextField alloc]initWithFrame:CGRectMake(145, 215, 250, 44)];
	self.passwordField.delegate = self;
	[self.passwordField setSecureTextEntry:YES];
	[self.passwordField setBackgroundColor:[UIColor whiteColor]];
	self.passwordField.borderStyle = UITextBorderStyleLine;
	self.passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	[self.passwordField setPlaceholder:@"Password"];
	[self.passwordField setReturnKeyType:UIReturnKeyNext];
	[self.view addSubview:self.passwordField];
	
	self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self.loginButton setFrame:CGRectMake(145, 277, 250, 44)];
	[self.loginButton setTitle:@"Sign in" forState:UIControlStateNormal];
	[self.loginButton addTarget:self action:@selector(loginWithCredentialsAndReturnError) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.loginButton];

	[self.usernameField becomeFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField.returnKeyType == UIReturnKeyDone) {
		[textField resignFirstResponder];
		[self loginWithCredentialsAndReturnError];
	} else {
		if (self.usernameField.text.length != 0) {
			[self.passwordField setReturnKeyType:UIReturnKeyDone];
		} else {
			[self.passwordField setReturnKeyType:UIReturnKeyNext];
		}

		if (self.passwordField.text.length != 0) {
			[self.usernameField setReturnKeyType:UIReturnKeyDone];
		} else {
			[self.usernameField setReturnKeyType:UIReturnKeyNext];
		}
		
		if (textField == self.passwordField) 
			[self.usernameField becomeFirstResponder];
		else
			[self.passwordField becomeFirstResponder];
	}
	
	return YES;
}

#pragma mark - Login

-(void)loginWithCredentialsAndReturnError {
	__block CGFloat errAlpha = 0;
	NSMutableString *errStr = [[NSMutableString alloc]init];
	if (self.usernameField.text.length == 0) {
		[errStr appendString:@"Please enter a User Name \n"];
		errAlpha = 1;
	} else {
		if ([self validateEmail:self.usernameField.text]) {
			[errStr appendString:@"Please use your GitHub username to login, not an email address. \n"];
			errAlpha = 1;
		}
	}
	if (self.passwordField.text.length == 0) {
		[errStr appendString:@"Please enter a Password \n"];
		errAlpha = 1;
	}
	if (errAlpha == 0) {
		KRGithubAccount *newAccount = [[KRGithubAccount alloc]initWithUsername:self.usernameField.text password:self.passwordField.text];
		@weakify(self);
		RACSignal *loginSignal = [newAccount login];
		[loginSignal subscribeCompleted:^ {
			@strongify(self);
			[self _dismissForSuccessfulValidationWithAccount:newAccount];
		}];
		[loginSignal subscribeError:^(NSError *error) {
			@strongify(self);
			switch (error.code) {
				case 503:
					[errStr appendString:@"GitHub appears to be unreachable.  Check that you have a valid connection to the internet."];
					errAlpha = 1;
					[self _reEnableForFailedValidationWithErrorMessage:errStr];
					break;
				default:
					[errStr appendString:@"Your credentials are invalid.  Please enter another login."];
					errAlpha = 1;
					break;
			}
			[self _reEnableForFailedValidationWithErrorMessage:errStr];
		}];

	} else {
		[self _reEnableForFailedValidationWithErrorMessage:errStr];
	}
}


-(void)_disableForValidation {
	[self.usernameField setUserInteractionEnabled:NO];
	[self.passwordField setUserInteractionEnabled:NO];
	[self.loginButton setUserInteractionEnabled:NO];
}

-(void)_reEnableForFailedValidationWithErrorMessage:(NSString*)message {
	WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.view title:@"Login Error!" message:message];
    [NSOperationQueue addNoticeView:notice filterDuplicates:YES];
	
	[self.usernameField setUserInteractionEnabled:YES];
	[self.passwordField setUserInteractionEnabled:YES];
	[self.loginButton setUserInteractionEnabled:YES];
}

-(void)_dismissForSuccessfulValidationWithAccount:(KRGithubAccount*)account {
	[[NSNotificationCenter defaultCenter]postNotificationName:GPLoginViewControllerDidSuccessfulyLoginNotification object:account];
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	
    return [emailTest evaluateWithObject:candidate];
}

#pragma mark - Memory Warnings

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
