//
//  IDKAppDelegate.h
//  IDK3
//
//  Created by Mahdi Makki on 7/15/14.
//  Copyright (c) 2014 IDKNY. All rights reserved.
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
