//
//  ZMAppDelegate.h
//  Diary
//
//  Created by Anthony Ho on 08/09/2014.
//  Copyright (c) 2014 ZeroMondays. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
