//
//  GPAppDelegate.h
//  GitPad
//
//  Created by Robert Widmann on 11/29/12.
//  Copyright (c) 2012 CodaFi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UAGithubEngine, GPControlCenterViewController, GPMainViewController;

@interface GPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GPControlCenterViewController *controlCenterViewController;
@property (strong, nonatomic) GPMainViewController *mainViewController;
@property (strong, nonatomic) UINavigationController *navigationController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL*)applicationDocumentsDirectory;

@end
