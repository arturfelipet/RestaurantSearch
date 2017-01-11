//
//  DatabaseManager.m
//
//
//  Created by Artur Felipe on 11/15/14.
//  Copyright © 2014 Artur Felipe. All rights reserved.
//

#import "DatabaseManager.h"

@interface DatabaseManager()

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation DatabaseManager
@synthesize managedObjectContext 		= _managedObjectContext;
@synthesize managedObjectModel 			= _managedObjectModel;
@synthesize persistentStoreCoordinator 	= _persistentStoreCoordinator;

#pragma mark - Initialization

+ (instancetype)sharedInstance
{
    static DatabaseManager *instance = nil;
    static dispatch_once_t onceToken;
    
    if (instance) return instance;
    
    dispatch_once(&onceToken, ^{
        instance = [DatabaseManager alloc];
        instance = [instance init];
        
        [instance setDataModelURL:Nil];
        [instance setStorePath:Nil];
    });
    
    return instance;
}

- (void)reset
{
    _managedObjectContext = nil;
    _managedObjectModel = nil;
    _persistentStoreCoordinator = nil;
}

#pragma mark - Fetch

- (NSArray *)fetchData:(NSString*)entityName predicate:(NSPredicate*)predicate offset:(NSUInteger)offset limit:(NSUInteger)limit sortBy:(NSString*)sortBy ascending:(BOOL)ascending error:(NSError**)error
{
    //NSLog(@"DatabaseManager fetchData %@", entityName );
    
    if (!entityName)
    {
        *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:ERROR_DATABASEMANAGER_FETCH_ENTITY_NIL userInfo:@{@"description": @"EntityName cannot be nil"}];
        return nil;
    }
    
    NSManagedObjectContext *context = [self managedObjectContext];
    if (!context)
    {
        *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:ERROR_DATABASEMANAGER_FETCH_CONTEXT_NIL userInfo:@{@"description": @"ManagedContext cannot be nil"}];
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    fetchRequest.fetchOffset = offset;
    
    if (limit > 0)
        fetchRequest.fetchLimit = limit;
    if (sortBy){
        if([sortBy rangeOfString:@","].location != NSNotFound){
            NSMutableArray *resultDescriptors = [[NSMutableArray alloc] init];
            NSArray *descriptors = [sortBy componentsSeparatedByString:@","];
            
            for(NSString *descriptor in descriptors){
                [resultDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:descriptor ascending:ascending]];
            }
            
            fetchRequest.sortDescriptors = [resultDescriptors copy];
        }
        else{
            fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:sortBy ascending:ascending]];
        }
    }
    if (predicate)
        fetchRequest.predicate = predicate;
    
    @try
    {
        NSArray *objects = [context executeFetchRequest:fetchRequest error:error];
        return objects;
    }
    @catch (NSException *exception)
    {
        *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:ERROR_DATABASEMANAGER_FETCH_CATCH userInfo:@{@"exception": exception}];
        return nil;
    }
}

- (NSUInteger)countFetchData:(NSString*)entityName predicate:(NSPredicate*)predicate offset:(NSUInteger)offset limit:(NSUInteger)limit sortBy:(NSString*)sortBy ascending:(BOOL)ascending error:(NSError**)error
{
    //NSLog(@"DatabaseManager fetchData %@", entityName );
    
    if (!entityName)
    {
        *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:ERROR_DATABASEMANAGER_FETCH_ENTITY_NIL userInfo:@{@"description": @"EntityName cannot be nil"}];
        return NSNotFound;
    }
    
    NSManagedObjectContext *context = [self managedObjectContext];
    if (!context)
    {
        *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:ERROR_DATABASEMANAGER_FETCH_CONTEXT_NIL userInfo:@{@"description": @"ManagedContext cannot be nil"}];
        return NSNotFound;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    fetchRequest.fetchOffset = offset;
    
    if (limit > 0)
    fetchRequest.fetchLimit = limit;
    if (sortBy){
        if([sortBy rangeOfString:@","].location != NSNotFound){
            NSMutableArray *resultDescriptors = [[NSMutableArray alloc] init];
            NSArray *descriptors = [sortBy componentsSeparatedByString:@","];
            
            for(NSString *descriptor in descriptors){
                [resultDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:descriptor ascending:ascending]];
            }
            
            fetchRequest.sortDescriptors = [resultDescriptors copy];
        }
        else{
            fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:sortBy ascending:ascending]];
        }
    }
    if (predicate)
    fetchRequest.predicate = predicate;
    
    @try
    {
        NSUInteger counter = [context countForFetchRequest:fetchRequest error:error];
        return counter;
    }
    @catch (NSException *exception)
    {
        *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:ERROR_DATABASEMANAGER_FETCH_CATCH userInfo:@{@"exception": exception}];
        return NSNotFound;
    }
}

- (id)createObject:(NSString*)entityName error:(NSError**)error
{
    if (!entityName)
    {
        *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:ERROR_DATABASEMANAGER_CREATE_ENTITY_NIL userInfo:@{@"description": @"Cannot create while entityName is nil"}];
        return nil;
    }
    
    NSManagedObjectContext *context = [self managedObjectContext];
    if (!context)
    {
        *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:ERROR_DATABASEMANAGER_CREATE_CONTEXT_NIL userInfo:@{@"description": @"Cannot create while ManagedObjectContext is nil"}];
        return nil;
    }
    
    @try
    {
        id model = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
        return model;
    }
    @catch (NSException *exception)
    {
        *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:ERROR_DATABASEMANAGER_CREATE_CATCH userInfo:@{@"exception": exception}];
        return nil;
    }
}

- (void)deleteObject:(id)obj error:(NSError**)error
{
    NSManagedObjectContext *context = self.managedObjectContext;
    
    if (!context)
    {
        *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:ERROR_DATABASEMANAGER_DELETE_CONTEXT_NIL userInfo:@{@"description": @"Cannot delete while ManagedObjectContext is nil"}];
        return;
    }
    
    [context deleteObject:obj];
    
    [self saveContext:error];
}

- (BOOL)cleanObjectsOfEntity:(NSString*)entityName outdatedSince:(NSDate*)date error:(NSError**)error
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSArray *objects = [self fetchData:entityName predicate:[NSPredicate predicateWithFormat:@"(lastUpdated < %@) AND (isOffline == NO)", date] offset:0 limit:0 sortBy:nil ascending:YES error:error];
    
    if(date){
        objects = [self fetchData:entityName predicate:[NSPredicate predicateWithFormat:@"(lastUpdated < %@) AND (isOffline == NO)", date] offset:0 limit:0 sortBy:nil ascending:YES error:error];
    }
    else{
        objects = [self fetchData:entityName predicate:nil offset:0 limit:0 sortBy:nil ascending:YES error:error];
    }
    
    for (NSManagedObject *obj in objects)
        [context deleteObject:obj];
    
    [self saveContext:error];
    
    if (*error == nil)
        return YES;
    return NO;
}



#pragma mark - Core Data

- (BOOL)saveContext:(NSError**)error
{
    NSManagedObjectContext *objectContext = self.managedObjectContext;
    
    if (objectContext != nil)
    {
        if ([objectContext hasChanges])
            return [objectContext save:error];
        else
            return YES;
    }
    else
    {
        *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:ERROR_COREDATA_CONTEXT_NIL userInfo:@{@"description" : @"Cannot save while ManagedObjectConext is nil"}];
        return NO;
    }
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
        return _managedObjectContext;
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator == nil)
        return nil;
    
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
        return _managedObjectModel;
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.dataModelURL];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
        return _persistentStoreCoordinator;
    
    NSManagedObjectModel *model = [self managedObjectModel];
    if (model == nil)
        return nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES
                              };
    
    NSError *error;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.storePath options:options error:&error])
    {
        NSLog(@"PersistentStoreCoordinator error: %@, %@", error, [error userInfo]);
        return nil;
    }
    
    return _persistentStoreCoordinator;
}

- (NSArray*)cleanableEntityNames
{
    NSMutableArray *entityNames = [[NSMutableArray alloc] init];
    
    for (NSEntityDescription *entityDescription in [[self managedObjectModel] entities])
        if ([entityDescription.attributesByName valueForKey:@"lastUpdated"] != nil)
            [entityNames addObject:entityDescription];
    
    return [entityNames valueForKey:@"name"];
}

@end
