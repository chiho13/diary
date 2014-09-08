//
//  ZMCoreDataStack.h
//  Diary
//
//  Created by Anthony Ho on 08/09/2014.
//  Copyright (c) 2014 ZeroMondays. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMCoreDataStack : NSObject

+ (instancetype)defaultsStack;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end
