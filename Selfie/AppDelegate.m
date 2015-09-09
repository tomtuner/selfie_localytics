//
//  AppDelegate.m
//  Selfie
//
//  Created by Thomas DeMeo on 9/9/15.
//  Copyright (c) 2015 Thomas DeMeo. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)processIntoCoreDataWithArray: (NSArray *) data {
    
    NSManagedObjectContext *moc = [self managedObjectContext];
    
    for (NSDictionary *record in data) {
        [self createNewObjectWithDictionary:record];
    }
    
    [self saveContext];
}

-(void) createNewObjectWithDictionary:(NSDictionary *) record {
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Posts" inManagedObjectContext:[self managedObjectContext]];
    
    [record enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([key isEqualToString:@"id"]) {
            key = @"identifier";
        }
        [self setValue:obj forKey:key forManagedObject:newManagedObject];
    }];
}

-(BOOL) removeAllCoreDataObjects {
    __block BOOL end = NO;
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext ];
    
    [managedObjectContext performBlockAndWait:^{
        NSArray *coreDataObjectArray = nil;
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Posts"];
        coreDataObjectArray = [managedObjectContext executeFetchRequest:request error:&error];
        //        NSLog(@"Shared Department: %@", coreDataObjectArray);
        for (NSManagedObject *managedObject in coreDataObjectArray)
        {
            [managedObjectContext deleteObject:managedObject];
        }
        BOOL saved = [managedObjectContext save:&error];
        if (!saved) {
            NSLog(@"Unable to save context after deleting records for class Departments because %@", error);
            //            return NO;
        }
        end = YES;
    }];
    return end;
}

- (void)setValue:(id)value forKey:(NSString *)key forManagedObject:(NSManagedObject *)managedObject {
   if ([value isKindOfClass:[NSDictionary class]]) {
       // Not a String
       if ([key isEqualToString:@"caption"]) {
           key = @"caption_text";
           value = [value objectForKey:@"text"];
           [managedObject setValue:value forKey:key];
       }else if ([key isEqualToString:@"user"]) {
           key = @"user_name";
           value = [value objectForKey:@"full_name"];
           [managedObject setValue:value forKey:key];
       }else if ([key isEqualToString:@"images"]) {
           key = @"large_image_url";
           value = [[value objectForKey:@"standard_resolution" ] objectForKey:@"url"];
           [managedObject setValue:value forKey:key];
       }
    } else if ([value isKindOfClass:[NSString class]]) {
        if (value == [NSNull null])
            value = nil;
        [managedObject setValue:value forKey:key];
    }
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.demeo.localytics.Selfie" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Selfie" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Selfie.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    [self.managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        BOOL saved = [self.managedObjectContext save:&error];
        if (!saved) {
            // do some real error handling
            NSLog(@"Could not save master context due to %@", error);
        }
    }];
}

@end
