//
//  GPAccountManager.m
//  GitPad
//
//  Created by Robert Widmann on 2/10/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "GPAccountManager.h"
#import "NPReachability.h"
#import <KrakenKit/KrakenKit.h>

@interface GPAccountManager ()

@property (nonatomic, strong) NSMutableArray *accounts;
@property (nonatomic, strong) NSMutableDictionary *accountHash;

@end

@implementation GPAccountManager

+ (GPAccountManager *) sharedManager
{
	static dispatch_once_t pred = 0;
	__strong static id _sharedObject = nil;
	dispatch_once(&pred, ^{
		_sharedObject = [[self alloc] init]; // or some other init method
	});
	return _sharedObject;
}

- (id) init
{
    if (self = [super init])
    {
		[self refreshAccounts];
		_accounts = [[NSMutableArray alloc]init];
		_accountHash = [NSMutableDictionary dictionary];
		[self _loadAccounts];
		[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_userDefaultsChanged:) name:NSUserDefaultsDidChangeNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_reachabilityHasChanged) name:NPReachabilityChangedNotification object:[NPReachability sharedInstance]];
    }
    return self;
}

-(void)dealloc {
	[[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)_userDefaultsChanged:(NSNotification*)notification {
	
}

- (void)setAccounts:(NSMutableArray *)accounts {
	[self.accountHash removeAllObjects];
	[_accounts setArray:accounts];
	for (KRGithubAccount *account in self.accounts) {
		[self.accountHash setObject:account forKey:account.email];
	}
}

- (void)addAccount:(KRGithubAccount*)account {
	[self.accounts addObject:account];
	[self.accountHash setObject:account forKey:account.email];
}

- (void)removeAccount:(KRGithubAccount*)account {
//	[account cancel];
	[self.accountHash removeObjectForKey:account.email];
	[self.accounts removeObject:account];
}

- (void)refreshAccounts {
	//NOOP
}


-(KRGithubAccount*)accountForEmail:(NSString*)email {
	return [self.accountHash objectForKey:email];
}

- (void)saveChanges {
	[self _saveAccounts];
}

- (void)_loadAccounts {
	NSArray *defaultsAccounts = [[NSUserDefaults standardUserDefaults]objectForKey:@"Accounts"];
	for (NSDictionary *infoDictionary in defaultsAccounts) {
		KRGithubAccount *newAccount = [[KRGithubAccount alloc]initWithDictionary:infoDictionary];
		[self.accounts addObject:newAccount];
		[self.accountHash setObject:newAccount forKey:newAccount.email];
	}
}

- (void)_saveAccounts {
	NSMutableArray *arrayOfAccounts = [NSMutableArray array];
	for (KRGithubAccount *account in self.accounts) {
//		[arrayOfAccounts addObject:[account info]];
	}
	[[NSUserDefaults standardUserDefaults]setObject:arrayOfAccounts forKey:@"Accounts"];
	[[NSUserDefaults standardUserDefaults]synchronize];
}


@end
