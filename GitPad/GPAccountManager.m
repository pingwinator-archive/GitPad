//
//  GPAccountManager.m
//  GitPad
//
//  Created by Robert Widmann on 2/10/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "GPAccountManager.h"
#import "NPReachability.h"
#import "SSKeychain.h"
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
		[self.accountHash setObject:account forKey:account.username];
	}
}

- (void)addAccount:(KRGithubAccount*)account {
	[self.accounts addObject:account];
	[self.accountHash setObject:account forKey:account.username];
}

- (void)removeAccount:(KRGithubAccount*)account {
//	[account cancel];
	[self.accountHash removeObjectForKey:account.username];
	[self.accounts removeObject:account];
}

- (KRGithubAccount*)accountForUsername:(NSString*)username {
	return [self.accountHash objectForKey:username];
}

- (void)saveChanges {
	[self _saveAccounts];
}

- (void)_loadAccounts {
	NSArray *defaultsAccounts = [[NSUserDefaults standardUserDefaults]objectForKey:@"Accounts"];
	for (NSDictionary *infoDict in defaultsAccounts) {
		NSString *password = [SSKeychain passwordForService:GPPasswordServiceConstant account:infoDict[@"login"]];
		KRGithubAccount *newAccount = [[KRGithubAccount alloc]initWithUsername:infoDict[@"login"] password:password];
		[self.accounts addObject:newAccount];
		[self.accountHash setObject:newAccount forKey:newAccount.username];
	}
}

- (void)_saveAccounts {
	NSMutableArray *arrayOfAccounts = [NSMutableArray array];
	for (KRGithubAccount *account in self.accounts) {
		[arrayOfAccounts addObject:[account dictionaryRepresentation]];
	}
	[[NSUserDefaults standardUserDefaults]setObject:arrayOfAccounts forKey:@"Accounts"];
	[[NSUserDefaults standardUserDefaults]synchronize];
}


@end
