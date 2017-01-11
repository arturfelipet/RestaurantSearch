//
//  DatabaseManager.h
//  
//
//  Created by Artur Felipe on 11/15/14.
//  Copyright © 2014 Artur Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BaseVO;

@interface DatabaseManager : NSObject

@property (strong, nonatomic) NSURL *dataModelURL, *storePath;

+ (DatabaseManager*)sharedInstance;

- (void)reset;

- (NSManagedObjectContext *)managedObjectContext;
- (BOOL)saveContext:(NSError**)error;

- (id)createObject:(NSString*)entityName error:(NSError**)error;
- (void)deleteObject:(id)obj error:(NSError**)error;

- (NSUInteger)countFetchData:(NSString*)entityName predicate:(NSPredicate*)predicate offset:(NSUInteger)offset limit:(NSUInteger)limit sortBy:(NSString*)sortBy ascending:(BOOL)ascending error:(NSError**)error;
- (NSArray *)fetchData:(NSString*)entityName predicate:(NSPredicate*)predicate offset:(NSUInteger)offset limit:(NSUInteger)limit sortBy:(NSString*)sortBy ascending:(BOOL)ascending error:(NSError**)error;

- (NSArray*)cleanableEntityNames;
- (BOOL)cleanObjectsOfEntity:(NSString*)entityName outdatedSince:(NSDate*)date error:(NSError**)error;

@end
