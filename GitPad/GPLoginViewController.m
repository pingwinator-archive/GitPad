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
#import "UAGithubEngine.h"

@implementation UIView (FindAndResignFirstResponder)
- (BOOL)findAndResignFirstResponder
{
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return YES;
    }
    for (UIView *subView in self.subviews) {
        if ([subView findAndResignFirstResponder])
            return YES;
    }
    return NO;
}
@end

@interface GPLoginViewController () <UITextFieldDelegate>

@property (nonatomic, assign) GPAppDelegate *delegate;

@property (nonatomic, strong) GPNavigationBar *navigationBar;

@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) UILabel *errorLabel;

@end

@implementation GPLoginViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
		_delegate = [[UIApplication sharedApplication]delegate];
    }
    return self;
}

- (void)viewDidLoad
{
	// Do any additional setup after loading the view.
    [super viewDidLoad];
	self.navigationBar = [[GPNavigationBar alloc]initWithFrame:CGRectMake(0, 0, 540, 44)];
	self.navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[self.navigationBar setTitle:@"Login"];
	[self.view addSubview:self.navigationBar];
	
	self.usernameField = [[UITextField alloc]initWithFrame:CGRectMake(145, 163, 250, 44)];
	self.usernameField.delegate = self;
	[self.usernameField setBackgroundColor:[UIColor whiteColor]];
	self.usernameField.borderStyle = UITextBorderStyleBezel;
	self.usernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	[self.usernameField setPlaceholder:@"Username"];
	[self.usernameField setReturnKeyType:UIReturnKeyNext];
	[self.view addSubview:self.usernameField];
	
	self.passwordField = [[UITextField alloc]initWithFrame:CGRectMake(145, 215, 250, 44)];
	self.passwordField.delegate = self;
	[self.passwordField setSecureTextEntry:YES];
	[self.passwordField setBackgroundColor:[UIColor whiteColor]];
	self.passwordField.borderStyle = UITextBorderStyleBezel;
	self.passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	[self.passwordField setPlaceholder:@"Password"];
	[self.passwordField setReturnKeyType:UIReturnKeyNext];
	[self.view addSubview:self.passwordField];
	
	self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self.loginButton setFrame:CGRectMake(145, 277, 250, 44)];
	[self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
	[self.loginButton addTarget:self action:@selector(loginWithCredentialsAndReturnError) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.loginButton];
	
	self.errorLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 392, 500, 188)];
	[self.errorLabel setNumberOfLines:4];
	[self.errorLabel setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:self.errorLabel];
	
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
	[self.view findAndResignFirstResponder];
	[self _disableForValidation];
	__block CGFloat errAlpha = 0;
	NSMutableString *errStr = [[NSMutableString alloc]init];
	if (self.usernameField.text.length == 0) {
		[errStr appendString:@"Please enter a User Name \n"];
		errAlpha = 1;
	} else {
		//NO EMAILS
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
		 self.delegate.githubEngine = [[UAGithubEngine alloc]initWithUsername:self.usernameField.text password:self.passwordField.text withReachability:YES];
		[self.delegate.githubEngine repositoriesWithSuccess:^(id response) {
			[self _dismissForSuccessfulValidation];
		} failure:^(NSError *error) {
			[errStr appendString:@"Your credentials are invalid.  Please enter another login"];
			errAlpha = 1;
		}];
	} else {
		[self _reEnableForFailedValidation];
	}
	[self.errorLabel setText:[errStr copy]];
	[UIView animateWithDuration:.5 animations:^{
		[self.errorLabel setAlpha:errAlpha];
	}];
}

-(void)_disableForValidation {
	[self.usernameField setUserInteractionEnabled:NO];
	[self.passwordField setUserInteractionEnabled:NO];
	[self.loginButton setUserInteractionEnabled:NO];
}

-(void)_reEnableForFailedValidation {
	[self.usernameField setUserInteractionEnabled:YES];
	[self.passwordField setUserInteractionEnabled:YES];
	[self.loginButton setUserInteractionEnabled:YES];
}

-(void)_dismissForSuccessfulValidation {
	[[NSNotificationCenter defaultCenter]postNotificationName:GPLoginViewControllerDidSuccessfulyLoginNotification object:nil];
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
