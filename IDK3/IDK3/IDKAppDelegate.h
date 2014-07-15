//
//  IDKAppDelegate.h
//  IDK3
//
//  Created by SATOKO HIGHSTEIN on 7/1/14.
//  Copyright (c) 2014 SATOKO HIGHSTEIN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
